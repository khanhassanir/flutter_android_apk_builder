class SynonymNormalizer {
  // Phrase replacements applied before word-level substitution (longer first)
  static const Map<String, String> _phrases = {
    'low back': 'lower back',
    'mid back': 'upper back',
    'middle back': 'upper back',
    'between shoulder blades': 'upper back',
    'killing me': 'severe pain',
    'drives me crazy': 'severe pain',
    'bothering me': 'pain',
    'giving me trouble': 'pain',
    'can not': "can't",
    'cannot move': "can't move",
    'base of skull': 'neck headache',
    'first steps': 'plantar heel pain',
    'morning steps': 'plantar heel pain',
    'first thing morning': 'morning stiffness',
    'it band': 'it band',
    'iliotibial band': 'it band',
    'lateral knee': 'lateral knee pain',
    'outer knee': 'lateral knee pain',
    'back of ankle': 'achilles',
    'back of heel': 'achilles',
    'heel cord': 'achilles',
    'shin bone': 'shin splints',
    'shin pain': 'shin splints',
    'pulled hamstring': 'hamstring strain',
    'back of thigh': 'hamstring',
    'outer hip': 'hip bursitis',
    'side of hip': 'hip bursitis',
    'deep buttock': 'piriformis',
    'pain everywhere': 'widespread pain',
    'all over pain': 'widespread pain',
    'bone density': 'osteoporosis',
    'brittle bones': 'osteoporosis',
    'curved spine': 'scoliosis',
    'spine curve': 'scoliosis',
    'wrist pain': 'wrist pain',
    'elbow pain': 'elbow pain',
    'tennis elbow': 'tennis elbow',
    'golfers elbow': 'golfer\'s elbow',
    'hand pain': 'wrist pain',
  };

  // Word-level synonym → canonical form
  static const Map<String, String> _words = {
    // Pain / discomfort descriptors
    'hurt': 'pain',
    'hurts': 'pain',
    'hurting': 'pain',
    'aches': 'pain',
    'aching': 'pain',
    'sore': 'pain',
    'soreness': 'pain',
    'tender': 'pain',
    'throbbing': 'pain',
    'stinging': 'pain',
    'bothering': 'pain',
    'bothers': 'pain',
    'bother': 'pain',
    'suffering': 'pain',
    'discomfort': 'pain',
    'agony': 'pain',
    'troubles': 'pain',

    // Sharp / acute
    'stabbing': 'sharp',
    'shooting': 'sharp',
    'intense': 'sharp',
    'acute': 'sharp',
    'sudden': 'sharp',
    'knife': 'sharp',

    // Severity
    'terrible': 'severe',
    'awful': 'severe',
    'horrible': 'severe',
    'extreme': 'severe',
    'excruciating': 'severe',
    'unbearable': 'severe',
    'killing': 'severe',
    'really bad': 'severe',
    'very bad': 'severe',

    // Duration → chronic signals
    'constant': 'chronic',
    'persistent': 'chronic',
    'ongoing': 'chronic',
    'always': 'chronic',
    'forever': 'chronic',

    // Stiffness
    'stiffness': 'stiff',
    'tightness': 'tight',
    'rigid': 'stiff',
    'locked': 'stiff',

    // Inflammation / swelling
    'inflamed': 'inflamed',
    'inflammation': 'inflamed',
    'swollen': 'swelling',
    'swells': 'swelling',
    'puffy': 'swelling',

    // Spasm / cramp
    'cramping': 'spasm',
    'cramp': 'spasm',
    'cramps': 'spasm',

    // Mobility
    'cannot': "can't",
    'cant': "can't",
    'unable': "can't",
    'difficult': 'trouble',
    'difficulty': 'trouble',
    'struggling': 'trouble',
    'struggle': 'trouble',

    // Body part synonyms
    'spine': 'back',
    'spinal': 'back',
    'vertebra': 'back',
    'vertebrae': 'back',
    'backbone': 'back',
    'lumbar': 'lower back',
    'lumbago': 'lower back',
    'cervical': 'neck',
    'thoracic': 'upper back',
    'gluteal': 'glute',
    'buttock': 'buttock',
    'buttocks': 'buttock',
    'heel': 'heel',
    'heels': 'heel',
    'patella': 'kneecap',
    'patellar': 'kneecap',
    'psoas': 'hip flexor',
    'iliopsoas': 'hip flexor',
    'achilles': 'achilles',
    'hamstrings': 'hamstring',
    'hamstring': 'hamstring',
    'fibromyalgia': 'fibromyalgia',
    'piriformis': 'piriformis',
    'scoliosis': 'scoliosis',
    'osteoporosis': 'osteoporosis',
    'osteoarthritis': 'arthritis',
    'bursitis': 'bursitis',
    'tendinopathy': 'tendinopathy',
    'tendinitis': 'tendinopathy',
    'tendonitis': 'tendinopathy',
    'calf': 'calves',
    'calves': 'calves',
    'shin': 'shin splints',
    'forearm': 'forearm',
    'wrist': 'wrist',
    'elbow': 'elbow',
    'groin': 'groin',

    // Greetings
    'hi': 'hello',
    'hey': 'hello',
    'hiya': 'hello',
    'howdy': 'hello',
    'sup': 'hello',
    'yo': 'hello',
    'greetings': 'hello',
    'heya': 'hello',
    'morning': 'good morning',
    'evening': 'good evening',

    // Common informal contractions (no apostrophe)
    'im': "i'm",
    'ive': "i've",
    'dont': "don't",
    'doesnt': "doesn't",
    'wont': "won't",
    'shouldnt': "shouldn't",
    'isnt': "isn't",
  };

  static String normalize(String input) {
    String text = input.toLowerCase();

    // Apply phrase replacements first (to catch multi-word patterns before splitting)
    for (final entry in _phrases.entries) {
      text = text.replaceAll(entry.key, entry.value);
    }

    // Apply word-level replacements
    final tokens = text.split(RegExp(r'\s+'));
    return tokens.map((w) => _words[w] ?? w).join(' ');
  }
}
