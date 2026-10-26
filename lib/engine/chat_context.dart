/// Tracks the active conversation state across turns.
///
/// When [step] > 0 the bot is inside a sequential question flow and
/// [answers] accumulates the user's responses. When [step] == 0 but
/// [topic] is set, simple contextual routing (short follow-ups) is active.
class ChatContext {
  final String? topic;
  final int step;                    // 0 = no flow; 1+ = flow in progress
  final Map<String, String> answers; // answers gathered so far in the flow
  final int remainingTurns;          // for non-flow contextual routing

  const ChatContext({
    this.topic,
    this.step = 0,
    this.answers = const {},
    this.remainingTurns = 0,
  });

  static const empty = ChatContext();

  bool get inFlow => step > 0 && topic != null;
  bool get active => topic != null && (inFlow || remainingTurns > 0);

  /// Start a fresh question flow for [topic].
  ChatContext startFlow(String t) => ChatContext(
        topic: t,
        step: 1,
        answers: const {},
        remainingTurns: 8,
      );

  /// Advance to the next flow step, saving [newAnswers].
  ChatContext advanceFlow(Map<String, String> newAnswers) => ChatContext(
        topic: topic,
        step: step + 1,
        answers: Map.unmodifiable(newAnswers),
        remainingTurns: remainingTurns,
      );

  /// End the flow; keep topic alive for short follow-ups.
  ChatContext endFlow({int turns = 3}) => ChatContext(
        topic: topic,
        step: 0,
        answers: const {},
        remainingTurns: turns,
      );

  /// Set topic without starting a flow (contextual routing only).
  ChatContext setTopic(String t, {int turns = 3}) => ChatContext(
        topic: t,
        step: 0,
        answers: const {},
        remainingTurns: turns,
      );

  ChatContext tick() => ChatContext(
        topic: topic,
        step: step,
        answers: answers,
        remainingTurns: (remainingTurns - 1).clamp(0, 99),
      );

  ChatContext clear() => empty;
}

// ── Contextual route table (used outside flows) ───────────────────────────
// Maps topic → { keyword → intent-id }

const Map<String, Map<String, String>> contextualRoutes = {
  'lower_back': {
    'sharp': 'lower_back_sharp',
    'stabbing': 'lower_back_sharp',
    'shooting': 'lower_back_sharp',
    'sudden': 'lower_back_sharp',
    'stiff': 'lower_back_stiffness',
    'stiffness': 'lower_back_stiffness',
    'tight': 'lower_back_stiffness',
    'morning': 'lower_back_stiffness',
    'dull': 'lower_back_chronic',
    'ache': 'lower_back_chronic',
    'months': 'lower_back_chronic',
    'years': 'lower_back_chronic',
    'chronic': 'lower_back_chronic',
    'constant': 'lower_back_chronic',
    'burning': 'lower_back_sciatica',
    'leg': 'lower_back_sciatica',
    'radiating': 'lower_back_sciatica',
    'tingling': 'lower_back_sciatica',
    'sitting': 'lower_back_sitting',
    'desk': 'lower_back_sitting',
    'office': 'lower_back_sitting',
  },
  'neck': {
    'morning': 'neck_morning',
    'sleep': 'neck_morning',
    'pillow': 'neck_morning',
    'computer': 'neck_tech',
    'phone': 'neck_tech',
    'screen': 'neck_tech',
    'desk': 'neck_tech',
    'arm': 'neck_nerve',
    'tingling': 'neck_nerve',
    'numbness': 'neck_nerve',
    'fingers': 'neck_nerve',
    'headache': 'neck_headache',
    'head': 'neck_headache',
  },
  'shoulder': {
    'clicking': 'shoulder_impingement',
    'snapping': 'shoulder_impingement',
    'overhead': 'shoulder_impingement',
    'frozen': 'shoulder_frozen',
    'stiff': 'shoulder_frozen',
    'night': 'shoulder_sleep',
    'sleeping': 'shoulder_sleep',
    'weakness': 'shoulder_rotator',
    'weak': 'shoulder_rotator',
  },
  'upper_back': {
    'posture': 'upper_back_posture',
    'slouch': 'upper_back_posture',
    'desk': 'upper_back_desk',
    'computer': 'upper_back_desk',
    'sharp': 'upper_back_sharp',
    'spasm': 'upper_back_sharp',
  },
  'hip': {
    'tight': 'hip_flexor',
    'flexor': 'hip_flexor',
    'groin': 'hip_flexor',
    'arthritis': 'hip_arthritis',
  },
  'knee': {
    'swollen': 'knee_swelling',
    'swelling': 'knee_swelling',
    'stairs': 'knee_patella',
    'kneecap': 'knee_patella',
    'arthritis': 'knee_arthritis',
  },
  'ankle': {
    'twisted': 'ankle_sprain',
    'rolled': 'ankle_sprain',
    'heel': 'plantar_fasciitis',
    'morning': 'plantar_fasciitis',
  },
};

// ── Intent → topic mapping ────────────────────────────────────────────────

const Map<String, String> intentTopics = {
  'lower_back_general': 'lower_back',
  'lower_back_sharp': 'lower_back',
  'lower_back_stiffness': 'lower_back',
  'lower_back_chronic': 'lower_back',
  'lower_back_sitting': 'lower_back',
  'lower_back_sciatica': 'lower_back',
  'neck_general': 'neck',
  'neck_morning': 'neck',
  'neck_tech': 'neck',
  'neck_nerve': 'neck',
  'neck_headache': 'neck',
  'shoulder_general': 'shoulder',
  'shoulder_frozen': 'shoulder',
  'shoulder_impingement': 'shoulder',
  'shoulder_sleep': 'shoulder',
  'shoulder_rotator': 'shoulder',
  'upper_back_general': 'upper_back',
  'upper_back_posture': 'upper_back',
  'upper_back_desk': 'upper_back',
  'upper_back_sharp': 'upper_back',
  'hip_general': 'hip',
  'hip_flexor': 'hip',
  'hip_arthritis': 'hip',
  'knee_general': 'knee',
  'knee_patella': 'knee',
  'knee_arthritis': 'knee',
  'knee_swelling': 'knee',
  'ankle_general': 'ankle',
  'ankle_sprain': 'ankle',
  'plantar_fasciitis': 'ankle',
};
