import '../data/chat_knowledge_base.dart';

/// Stop words excluded from semantic scoring — they carry no topical signal.
const _stopWords = {
  'i', 'me', 'my', 'am', 'is', 'are', 'was', 'be', 'been', 'have', 'has',
  'had', 'do', 'does', 'did', 'a', 'an', 'the', 'and', 'or', 'but', 'in',
  'on', 'at', 'to', 'for', 'of', 'with', 'by', 'from', 'up', 'about',
  'it', 'its', 'this', 'that', 'so', 'if', 'as', 'not', 'can', 'will',
  'just', 'also', 'very', 'really', 'quite', 'some', 'any', 'all', 'get',
  'got', 'getting', 'going', 'go', 'feel', 'feels', 'feeling', 'lot',
  'bit', 'little', 'kind', 'sort', 'right', 'left', 'both',
  'now', 'since', 'like', 'what', 'how', 'when', 'where', 'why', 'who',
};

/// Semantic intent matcher using word-overlap cosine similarity.
///
/// Used as the third matching layer in [ChatEngine] — only reached when
/// both exact and synonym-normalised keyword matching fail.
class SemanticMatcher {
  /// Pre-computed intent → key word sets, built once per app run.
  static late final List<_IntentVector> _vectors;
  static bool _ready = false;

  /// Call once at app start (or lazily on first use).
  static void build() {
    _vectors = chatKnowledgeBase.map((intent) {
      final words = <String>{};
      for (final phrase in intent.triggers) {
        for (final kw in phrase) {
          words.addAll(_tokenize(kw));
        }
      }
      return _IntentVector(intent, words);
    }).toList();
    _ready = true;
  }

  /// Returns the best-matching [ChatIntent] if the overlap score clears
  /// [threshold], or null if no intent is a good enough match.
  static ChatIntent? findBest(String normalizedInput, {double threshold = 0.28}) {
    if (!_ready) build();

    final inputWords = _tokenize(normalizedInput);
    if (inputWords.isEmpty) return null;

    ChatIntent? best;
    double bestScore = 0;

    for (final v in _vectors) {
      if (v.words.isEmpty) continue;

      // Coverage: fraction of input words that appear in intent's trigger words
      final overlap = inputWords.intersection(v.words).length;
      if (overlap == 0) continue;

      final coverage = overlap / inputWords.length;
      final score = coverage * v.intent.priority;

      if (score > bestScore) {
        bestScore = score;
        best = v.intent;
      }
    }

    return bestScore >= threshold ? best : null;
  }

  static Set<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .split(RegExp(r'[^a-z]+'))
        .where((w) => w.length > 2 && !_stopWords.contains(w))
        .toSet();
  }
}

class _IntentVector {
  final ChatIntent intent;
  final Set<String> words;
  const _IntentVector(this.intent, this.words);
}
