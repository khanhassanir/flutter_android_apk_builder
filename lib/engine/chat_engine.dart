import '../data/chat_knowledge_base.dart';
import 'chat_context.dart';
import 'conversation_flows.dart';
import 'semantic_matcher.dart';
import 'synonym_normalizer.dart';

class ChatResponse {
  final String message;
  final List<String> quickReplies;
  final List<String> exerciseIds;
  final String? planId;
  final String? browseTarget; // 'exercises' | 'plans' | null

  const ChatResponse({
    required this.message,
    this.quickReplies = const [],
    this.exerciseIds = const [],
    this.planId,
    this.browseTarget,
  });
}

/// Return type: bot response + updated conversation context.
typedef EngineResult = (ChatResponse, ChatContext);

/// Intent IDs that start a question flow instead of returning their
/// standard knowledge-base response directly.
const _flowTriggers = {
  'lower_back_general',
  'neck_general',
  'shoulder_general',
  'knee_general',
  'hip_general',
  'upper_back_general',
  'ankle_general',
};

class ChatEngine {
  /// Main entry point. Pass the current [ctx] in; get back the response
  /// and the updated [ChatContext] to persist for the next turn.
  static EngineResult respond(String input, ChatContext ctx) {
    final lower = input.toLowerCase().trim();
    if (lower.isEmpty) return (_fallback(), ctx);

    // ── Active question flow ──────────────────────────────────────────
    if (ctx.inFlow) return _handleFlowStep(lower, input, ctx);

    // ── Normal matching pipeline ──────────────────────────────────────
    return _resolveNormal(lower, ctx);
  }

  // ─────────────────────────────────────────────────────────────────────
  // FLOW HANDLING
  // ─────────────────────────────────────────────────────────────────────

  static EngineResult _handleFlowStep(
      String lower, String raw, ChatContext ctx) {
    final flow = topicFlows[ctx.topic];

    // If input looks like a completely different full query (> 7 words),
    // give the user a chance to escape the flow via normal matching.
    final wordCount = lower.split(RegExp(r'\s+')).length;
    if (wordCount > 7) {
      final (intent, score) = _findKeywordIntentWithScore(lower);
      if (intent != null &&
          score > 3 &&
          !_flowTriggers.contains(intent.id)) {
        return (_toResponse(intent), _nextContext(intent.id, ctx));
      }
    }

    if (flow == null) return _resolveNormal(lower, ctx);

    final question = flow.questionAt(ctx.step);
    if (question == null) return _resolveNormal(lower, ctx);

    // Parse user's answer
    final answerValue = question.parseAnswer(lower);
    final newAnswers = {...ctx.answers};
    if (answerValue.isNotEmpty) newAnswers[question.key] = answerValue;

    final ack = buildAck(question.key, answerValue);

    // Is there a next question?
    final nextStep = ctx.step + 1;
    final nextQ = flow.questionAt(nextStep);

    if (nextQ != null) {
      // Ask the next question, acknowledging this answer
      return (
        ChatResponse(
          message: '$ack\n\n${nextQ.message}',
          quickReplies: nextQ.quickReplies,
        ),
        ctx.advanceFlow(newAnswers),
      );
    }

    // All questions answered — resolve to the best specific intent
    final intentId = resolveIntentId(ctx.topic!, newAnswers);
    final intent = _findIntentById(intentId);
    if (intent != null) {
      final topic = intentTopics[intentId] ?? ctx.topic!;
      // Prepend ack of the final answer so the transition feels natural
      return (
        ChatResponse(
          message: '$ack\n\n${intent.response}',
          quickReplies: intent.quickReplies,
          exerciseIds: intent.exerciseIds,
          planId: intent.planId,
          browseTarget: intent.browseTarget,
        ),
        ctx.endFlow().setTopic(topic),
      );
    }

    return (_fallback(), ctx.clear());
  }

  // ─────────────────────────────────────────────────────────────────────
  // NORMAL MATCHING PIPELINE
  // ─────────────────────────────────────────────────────────────────────

  static EngineResult _resolveNormal(String lower, ChatContext ctx) {
    // Layer 0 — contextual follow-up (active topic, not in a flow)
    if (ctx.active && !ctx.inFlow) {
      final contextual = _contextualMatch(lower, ctx);
      if (contextual != null) {
        final topic = intentTopics[contextual.id] ?? ctx.topic!;
        return (_toResponse(contextual), ctx.setTopic(topic));
      }
    }

    // Layer 1 — exact keyword match on original input
    final (i1, _) = _findKeywordIntentWithScore(lower);
    if (i1 != null) {
      if (_flowTriggers.contains(i1.id)) return _startFlow(i1.id, ctx);
      return (_toResponse(i1), _nextContext(i1.id, ctx));
    }

    // Layer 2 — synonym-normalised keyword match
    final normalised = SynonymNormalizer.normalize(lower);
    if (normalised != lower) {
      final (i2, _) = _findKeywordIntentWithScore(normalised);
      if (i2 != null) {
        if (_flowTriggers.contains(i2.id)) return _startFlow(i2.id, ctx);
        return (_toResponse(i2), _nextContext(i2.id, ctx));
      }
    }

    // Layer 3 — semantic word-overlap fallback
    final i3 = SemanticMatcher.findBest(normalised);
    if (i3 != null) {
      if (_flowTriggers.contains(i3.id)) return _startFlow(i3.id, ctx);
      return (_toResponse(i3), _nextContext(i3.id, ctx));
    }

    return (_fallback(), ctx.tick());
  }

  // ─────────────────────────────────────────────────────────────────────
  // FLOW START
  // ─────────────────────────────────────────────────────────────────────

  static EngineResult _startFlow(String intentId, ChatContext ctx) {
    final topic = intentId.replaceAll('_general', '');
    final flow = topicFlows[topic];

    if (flow == null) {
      // No flow defined — fall back to standard intent response
      final intent = _findIntentById(intentId);
      if (intent != null) {
        return (_toResponse(intent), ctx.setTopic(topic));
      }
      return (_fallback(), ctx);
    }

    final firstQ = flow.questionAt(1)!;
    return (
      ChatResponse(
        message: '${flow.intro}\n\n${firstQ.message}',
        quickReplies: firstQ.quickReplies,
      ),
      ctx.startFlow(topic),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────

  static ChatIntent? _contextualMatch(String lower, ChatContext ctx) {
    final routes = contextualRoutes[ctx.topic];
    if (routes == null) return null;
    for (final word in lower.split(RegExp(r'[^a-z]+')).where((w) => w.length > 1)) {
      final id = routes[word];
      if (id != null) return _findIntentById(id);
    }
    return null;
  }

  static (ChatIntent?, double) _findKeywordIntentWithScore(String lower) {
    ChatIntent? best;
    double bestScore = 0;
    for (final intent in chatKnowledgeBase) {
      double score = 0;
      for (final phrase in intent.triggers) {
        if (phrase.every((kw) => lower.contains(kw))) {
          score += phrase.length * intent.priority;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = intent;
      }
    }
    return (bestScore > 0 ? best : null, bestScore);
  }

  static ChatContext _nextContext(String intentId, ChatContext current) {
    final topic = intentTopics[intentId];
    return topic != null ? current.setTopic(topic) : current.tick();
  }

  static ChatIntent? _findIntentById(String id) {
    for (final intent in chatKnowledgeBase) {
      if (intent.id == id) return intent;
    }
    return null;
  }

  static ChatResponse _toResponse(ChatIntent intent) => ChatResponse(
        message: intent.response,
        quickReplies: intent.quickReplies,
        exerciseIds: intent.exerciseIds,
        planId: intent.planId,
        browseTarget: intent.browseTarget,
      );

  static ChatResponse _fallback() => const ChatResponse(
        message:
            "I'm not sure I fully understood that. I can help with:\n\n• Pain areas: back, neck, shoulders, knees, hips, ankles\n• Exercise technique: just ask \"how to do [exercise name]\"\n• Recovery plans and how they work\n• Physio tips: posture, ice vs heat, sleep positions, stretching\n\nTry something like \"I have lower back pain\" or \"how do I do a bird dog\".",
        quickReplies: [
          'Lower back pain',
          'Neck pain',
          'Knee pain',
          'Show exercises',
        ],
      );
}
