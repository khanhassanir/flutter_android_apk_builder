/// A single question in a multi-turn conversation flow.
class FlowQuestion {
  final String key;                          // slot name stored in answers map
  final String message;                      // what the bot asks
  final List<String> quickReplies;
  final Map<String, List<String>> answerKeywords; // value → triggering keywords

  const FlowQuestion({
    required this.key,
    required this.message,
    required this.quickReplies,
    required this.answerKeywords,
  });

  /// Returns the matched answer value, or empty string if nothing matched.
  String parseAnswer(String input) {
    final lower = input.toLowerCase();
    for (final entry in answerKeywords.entries) {
      if (entry.value.any((kw) => lower.contains(kw))) return entry.key;
    }
    return '';
  }
}

/// A sequential question flow for one body-area topic.
class TopicFlow {
  final String topic;
  final String intro; // brief opening shown before Q1 (no question inside)
  final List<FlowQuestion> questions;

  const TopicFlow({
    required this.topic,
    required this.intro,
    required this.questions,
  });

  int get totalSteps => questions.length;
  FlowQuestion? questionAt(int step) =>
      (step >= 1 && step <= questions.length) ? questions[step - 1] : null;
}

// ── Flow definitions ──────────────────────────────────────────────────────

const Map<String, TopicFlow> topicFlows = {
  // ── LOWER BACK (3 questions) ──────────────────────────────────────
  'lower_back': TopicFlow(
    topic: 'lower_back',
    intro:
        'Lower back pain is the most common complaint I see. A few quick questions will let me give you much more specific advice.',
    questions: [
      FlowQuestion(
        key: 'pain_type',
        message: 'First — how would you describe the pain?',
        quickReplies: ['Sharp / stabbing', 'Dull ache', 'Stiff and tight', 'Burning'],
        answerKeywords: {
          'sharp': ['sharp', 'stabbing', 'shooting', 'knife', 'acute', 'intense', 'sudden'],
          'dull': ['dull', 'ache', 'aching', 'throb', 'throbbing'],
          'stiff': ['stiff', 'stiffness', 'tight', 'tightness', 'rigid', 'morning'],
          'burning': ['burning', 'burn', 'fire', 'hot', 'electric', 'heat'],
        },
      ),
      FlowQuestion(
        key: 'duration',
        message: 'How long have you had it — did it just start, or has it been going on for weeks or months?',
        quickReplies: ['Just started', 'A few weeks', 'Several months', 'Years on and off'],
        answerKeywords: {
          'recent': ['today', 'yesterday', 'just', 'recent', 'started', 'days', 'new', 'suddenly', 'this week', 'last night'],
          'weeks': ['week', 'weeks', 'fortnight', 'ten days'],
          'chronic': ['month', 'months', 'year', 'years', 'long', 'always', 'forever', 'chronic', 'constant', 'ages', 'while', 'persistent', 'ongoing'],
        },
      ),
      FlowQuestion(
        key: 'radiation',
        message: 'Last one — does the pain stay in your lower back, or does it travel down into your buttock or leg at all?',
        quickReplies: ['Stays in my back', 'Goes down my leg', 'Into my buttock too', 'Not sure'],
        answerKeywords: {
          'radiates': ['leg', 'legs', 'buttock', 'down', 'travels', 'radiates', 'radiating', 'thigh', 'calf', 'foot', 'tingling', 'yes', 'into my leg', 'into leg'],
          'stays': ['no', 'stays', 'local', 'just my back', 'only', 'isolated', 'back only'],
        },
      ),
    ],
  ),

  // ── NECK (2 questions) ────────────────────────────────────────────
  'neck': TopicFlow(
    topic: 'neck',
    intro:
        'Neck pain can come from several different sources. Two quick questions will let me target my advice much more accurately.',
    questions: [
      FlowQuestion(
        key: 'spread',
        message: 'First — does the pain stay in your neck, or does it spread anywhere?',
        quickReplies: ['Just my neck', 'Into my head', 'Down my arm or fingers', 'Into my shoulder'],
        answerKeywords: {
          'arm': ['arm', 'arms', 'finger', 'fingers', 'hand', 'tingling', 'numbness', 'electric', 'pins', 'needle'],
          'head': ['head', 'headache', 'skull', 'temple', 'forehead', 'eye', 'migraine'],
          'shoulder': ['shoulder', 'blade', 'scapula', 'upper back'],
          'local': ['no', 'just', 'only', 'neck', 'local', 'stays', 'here', 'my neck'],
        },
      ),
      FlowQuestion(
        key: 'timing',
        message: 'Is it worst first thing in the morning, or does it build during the day — especially when using a screen or phone?',
        quickReplies: ['Worst in the morning', 'Builds during the day', 'After screen / phone use', 'Pretty much all the time'],
        answerKeywords: {
          'morning': ['morning', 'wake', 'waking', 'woke', 'sleep', 'pillow', 'bed', 'night', 'arise', 'get up'],
          'daytime': ['day', 'afternoon', 'evening', 'computer', 'screen', 'phone', 'desk', 'work', 'sitting', 'laptop', 'builds', 'working', 'office'],
        },
      ),
    ],
  ),

  // ── SHOULDER (2 questions) ────────────────────────────────────────
  'shoulder': TopicFlow(
    topic: 'shoulder',
    intro:
        'Shoulder pain can have quite different causes and each needs a different approach. Two quick questions to narrow it down.',
    questions: [
      FlowQuestion(
        key: 'symptom',
        message: 'What\'s the main thing you notice — apart from the pain itself?',
        quickReplies: ['Clicking or snapping', "Hard to raise / very stiff", 'Worst at night', 'Feels weak'],
        answerKeywords: {
          'clicking': ['click', 'clicking', 'snap', 'snapping', 'catch', 'catching', 'pop', 'popping', 'crunch', 'grating'],
          'frozen': ['stiff', 'stiffness', 'raise', 'lift', 'range', 'frozen', 'stuck', 'overhead', 'above', 'behind back'],
          'night': ['night', 'sleeping', 'sleep', 'lying', 'bed', 'wake', 'woke', 'nighttime', 'nocturnal'],
          'weakness': ['weak', 'weakness', 'strength', 'heavy', 'drop', 'carry', 'hold', 'lifting'],
        },
      ),
      FlowQuestion(
        key: 'onset',
        message: 'Did it come on after a specific injury or incident, or has it developed gradually over time?',
        quickReplies: ['After an injury', 'Gradually over time', 'After a new activity', 'Not sure'],
        answerKeywords: {
          'injury': ['injury', 'injure', 'fell', 'fall', 'accident', 'sudden', 'playing', 'sport', 'caught', 'hit', 'throw', 'threw'],
          'gradual': ['gradual', 'gradually', 'slowly', 'time', 'months', 'weeks', 'built', 'repetitive', 'overuse', 'working', 'slowly'],
        },
      ),
    ],
  ),

  // ── KNEE (2 questions) ────────────────────────────────────────────
  'knee': TopicFlow(
    topic: 'knee',
    intro:
        'Knee pain location and how it started tells me a great deal. Two quick questions.',
    questions: [
      FlowQuestion(
        key: 'onset',
        message: 'Did the pain start after a specific injury or fall, or come on gradually over time?',
        quickReplies: ['After an injury', 'Gradually over time', 'After exercise', 'Not sure'],
        answerKeywords: {
          'injury': ['injury', 'injure', 'fell', 'fall', 'twist', 'twisted', 'landed', 'accident', 'sudden', 'sport', 'kicked', 'hit'],
          'gradual': ['gradual', 'gradually', 'slowly', 'time', 'built', 'repetitive', 'running', 'cycling', 'exercise', 'over time'],
        },
      ),
      FlowQuestion(
        key: 'location',
        message: 'Where is the pain mainly — and is there any swelling?',
        quickReplies: ['Front / kneecap area', 'Inside or outside', 'Knee is swollen', 'Behind the knee'],
        answerKeywords: {
          'front': ['front', 'kneecap', 'patella', 'stairs', 'stair', 'squat', 'squatting', 'cinema', 'sitting'],
          'swelling': ['swollen', 'swelling', 'swell', 'puffy', 'fluid', 'big', 'inflamed', 'warm', 'hot'],
          'side': ['inside', 'outside', 'inner', 'outer', 'medial', 'lateral', 'side', 'arthritis', 'bone', 'grind', 'grinding'],
          'behind': ['behind', 'back of knee', 'calf', 'popliteal', 'baker'],
        },
      ),
    ],
  ),

  // ── HIP (1 question) ──────────────────────────────────────────────
  'hip': TopicFlow(
    topic: 'hip',
    intro:
        'Hip pain can be the joint itself or the surrounding muscles — they need quite different treatment. One quick question.',
    questions: [
      FlowQuestion(
        key: 'area',
        message: 'Where exactly is the pain — front of hip / groin, deep in the joint, outer side, or in the buttock?',
        quickReplies: ['Front / groin area', 'Deep in the joint', 'Outer side of hip', 'In the buttock'],
        answerKeywords: {
          'front': ['front', 'groin', 'flexor', 'hip flexor', 'crease', 'psoas', 'bending', 'hip crease'],
          'arthritis': ['deep', 'joint', 'grind', 'grinding', 'arthritis', 'arthritic', 'bone', 'morning stiff', 'inside'],
          'outer': ['outer', 'outside', 'side', 'lateral', 'bursitis', 'trochanter', 'hip bone'],
          'buttock': ['buttock', 'buttocks', 'piriformis', 'glute', 'sit', 'sitting bone', 'sciatic'],
        },
      ),
    ],
  ),

  // ── UPPER BACK (1 question) ───────────────────────────────────────
  'upper_back': TopicFlow(
    topic: 'upper_back',
    intro:
        'Upper back pain is almost always posture or desk-related. One quick question to narrow it down.',
    questions: [
      FlowQuestion(
        key: 'type',
        message: 'Is it more of a constant dull ache, or does it come on sharply with certain movements?',
        quickReplies: ['Constant dull ache', 'Sharp with movement', 'Stiff and tight all day', 'After desk work'],
        answerKeywords: {
          'posture': ['constant', 'dull', 'ache', 'aching', 'all day', 'shoulder blades', 'between', 'tight', 'always', 'stiff'],
          'sharp': ['sharp', 'sudden', 'spasm', 'movement', 'twist', 'sneeze', 'breath', 'breathe', 'turn'],
          'desk': ['desk', 'computer', 'sitting', 'office', 'work', 'laptop', 'screen', 'after work'],
        },
      ),
    ],
  ),

  // ── ANKLE (1 question) ────────────────────────────────────────────
  'ankle': TopicFlow(
    topic: 'ankle',
    intro:
        'Ankle pain is most often from a sprain or from the heel area. One quick question.',
    questions: [
      FlowQuestion(
        key: 'onset',
        message: 'How did it start — did you twist or roll the ankle, or did the pain come on gradually?',
        quickReplies: ['Twisted or rolled it', 'Gradual / no clear cause', 'Heel pain in mornings', 'After exercise'],
        answerKeywords: {
          'injury': ['twist', 'twisted', 'roll', 'rolled', 'sprain', 'sprained', 'fell', 'landed', 'injured', 'sudden', 'tripped', 'caught'],
          'gradual': ['gradual', 'gradually', 'slowly', 'heel', 'morning', 'plantar', 'steps', 'walking', 'running', 'after exercise', 'no cause'],
        },
      ),
    ],
  ),
};

// ── Intent resolution ─────────────────────────────────────────────────────

/// Given collected [answers], returns the best specific intent ID for [topic].
String resolveIntentId(String topic, Map<String, String> answers) {
  switch (topic) {
    case 'lower_back':
      if (answers['radiation'] == 'radiates') return 'lower_back_sciatica';
      final quality = answers['pain_type'] ?? '';
      final duration = answers['duration'] ?? '';
      if (quality == 'stiff') return 'lower_back_stiffness';
      if (quality == 'sharp' || quality == 'burning') return 'lower_back_sharp';
      if (duration == 'chronic') return 'lower_back_chronic';
      if (duration == 'recent' || duration == 'weeks') return 'lower_back_sharp';
      return 'lower_back_general';

    case 'neck':
      if (answers['spread'] == 'arm') return 'neck_nerve';
      if (answers['spread'] == 'head') return 'neck_headache';
      if (answers['timing'] == 'morning') return 'neck_morning';
      if (answers['timing'] == 'daytime') return 'neck_tech';
      return 'neck_general';

    case 'shoulder':
      final symptom = answers['symptom'] ?? '';
      if (symptom == 'frozen') return 'shoulder_frozen';
      if (symptom == 'clicking') return 'shoulder_impingement';
      if (symptom == 'night') return 'shoulder_sleep';
      if (symptom == 'weakness') return 'shoulder_rotator';
      return 'shoulder_general';

    case 'knee':
      final location = answers['location'] ?? '';
      if (location == 'swelling') return 'knee_swelling';
      if (location == 'front') return 'knee_patella';
      if (location == 'side') return 'knee_arthritis';
      if (answers['onset'] == 'injury' && location.isEmpty) return 'knee_swelling';
      return 'knee_general';

    case 'hip':
      final area = answers['area'] ?? '';
      if (area == 'front') return 'hip_flexor';
      if (area == 'arthritis') return 'hip_arthritis';
      return 'hip_general';

    case 'upper_back':
      final type = answers['type'] ?? '';
      if (type == 'sharp') return 'upper_back_sharp';
      if (type == 'desk') return 'upper_back_desk';
      return 'upper_back_posture';

    case 'ankle':
      if (answers['onset'] == 'injury') return 'ankle_sprain';
      if (answers['onset'] == 'gradual') return 'plantar_fasciitis';
      return 'ankle_general';

    default:
      return '${topic}_general';
  }
}

// ── Acknowledgment messages ───────────────────────────────────────────────

/// Returns a brief, natural acknowledgment sentence for the user's answer.
String buildAck(String questionKey, String answerValue) {
  const acks = <String, Map<String, String>>{
    'pain_type': {
      'sharp': 'Sharp or stabbing pain — noted, that\'s a clear signal.',
      'dull': 'A dull ache — one of the most common patterns.',
      'stiff': 'Stiffness, especially in the morning, is a very telling sign.',
      'burning': 'Burning pain often points to nerve involvement — important to know.',
    },
    'duration': {
      'recent': 'Good — recent onset means faster recovery is possible.',
      'weeks': 'A few weeks in is actually a critical window where the right approach makes the biggest difference.',
      'chronic': 'Long-term pain needs a sustained strategy — noted.',
    },
    'radiation': {
      'radiates': 'Pain travelling into the leg is a significant finding — that points to nerve involvement.',
      'stays': 'Good — pain staying local is more straightforward to address.',
    },
    'spread': {
      'arm': 'Tingling or pain into the arm is an important finding.',
      'head': 'Neck pain spreading to the head is very common — and very treatable.',
      'shoulder': 'Neck pain spreading into the shoulder often involves the deeper muscles or nerve roots.',
      'local': 'Good — localised neck pain gives us a clear target.',
    },
    'timing': {
      'morning': 'Morning symptoms are a classic, recognisable pattern.',
      'daytime': 'Building through the day is the hallmark of postural or screen-related neck pain.',
    },
    'symptom': {
      'clicking': 'Clicking or snapping — that points to a mechanical issue with how the shoulder moves.',
      'frozen': 'Difficulty raising the arm with stiffness is a very distinct pattern — I can address this specifically.',
      'night': 'Night pain is one of the most disruptive shoulder symptoms.',
      'weakness': 'Weakness alongside pain is worth understanding carefully.',
    },
    'onset': {
      'injury': 'An injury-related onset is useful context — it changes the focus of treatment.',
      'gradual': 'Gradual onset typically signals a repetitive stress or overuse pattern.',
    },
    'location': {
      'front': 'Front-of-knee pain around the kneecap is a very common and very treatable pattern.',
      'swelling': 'Swelling is an important sign — the joint is actively reacting to something.',
      'side': 'Inside or outside knee pain helps me identify which structures are involved.',
      'behind': 'Pain behind the knee has a few distinct causes — noted.',
    },
    'area': {
      'front': 'Front-of-hip / groin pain is almost always the hip flexors — very fixable.',
      'arthritis': 'Deep hip joint pain points to the joint itself.',
      'outer': 'Outer hip pain is often bursitis or the IT band.',
      'buttock': 'Buttock pain can involve the piriformis muscle or sciatic nerve — important to identify.',
    },
    'type': {
      'posture': 'A constant ache is typically a postural and muscle fatigue issue.',
      'sharp': 'Sharp pain with movement usually points to muscle spasm — very treatable.',
      'desk': 'Desk-related upper back pain is incredibly common and very responsive to targeted exercises.',
    },
  };

  return acks[questionKey]?[answerValue] ?? 'Got it —';
}
