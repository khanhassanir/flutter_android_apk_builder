class KnowledgeMatch {
  final String message;
  final List<String> exerciseIds;
  final String? planId;
  final String? browseTarget;
  final List<String> quickReplies;

  const KnowledgeMatch({
    required this.message,
    this.exerciseIds = const [],
    this.planId,
    this.browseTarget,
    this.quickReplies = const [],
  });
}

class ChatKnowledgeBase {
  static KnowledgeMatch? match(String input) {
    final t = input.toLowerCase().trim();

    // ── App capabilities ──────────────────────────────────────────
    if (_any(t, [
      'what can you do', 'what do you offer', 'what does this app',
      'about you', 'how does this work', 'what are your features',
      'capabilities', 'what is physioai', 'tell me about',
    ])) {
      return const KnowledgeMatch(
        message:
            'PhysioAI is a self-managed physiotherapy companion designed to work entirely offline. Here\'s what I can help with:\n\n'
            '• Identify and demonstrate exercises specific to your pain area\n'
            '• Recommend structured recovery plans (7–21 days, clinically phased)\n'
            '• Guide proper technique with step-by-step instructions\n'
            '• Answer questions about pain, recovery timelines, and when to see a professional\n\n'
            'The library includes 80+ exercises and 15 recovery plans covering every major musculoskeletal condition — lower back, neck, shoulder, knee, hip, ankle, and more.',
        browseTarget: 'plans',
        quickReplies: [
          'Show me all exercises',
          'Show me recovery plans',
          'I have back pain',
          'Where should I start?'
        ],
      );
    }

    // ── Browse all exercises ──────────────────────────────────────
    if (_any(t, [
      'show exercises', 'all exercises', 'what exercises', 'exercise library',
      'browse exercises', 'list exercises', 'show me exercises',
    ])) {
      return const KnowledgeMatch(
        message:
            'The exercise library covers every major musculoskeletal area — neck, shoulders, upper and lower back, hips, core, knees, ankles, hamstrings, calves, wrists, and full-body balance. All exercises include step-by-step technique cues, sets, reps, and difficulty ratings.\n\nTap below to browse the full library.',
        browseTarget: 'exercises',
        quickReplies: [
          'Neck exercises',
          'Lower back exercises',
          'Knee exercises',
          'Hip exercises'
        ],
      );
    }

    // ── Browse all plans ──────────────────────────────────────────
    if (_any(t, [
      'show plans', 'all plans', 'what plans', 'recovery plans',
      'browse plans', 'list plans', 'treatment plans', 'show me plans',
    ])) {
      return const KnowledgeMatch(
        message:
            'There are 15 structured recovery plans ranging from 7 to 21 days:\n\n'
            '• Lower Back, Neck & Desk Worker, Sciatica\n'
            '• Knee Strengthening, Shoulder & Rotator Cuff, Frozen Shoulder\n'
            '• Hip Flexor & Core, Posture Correction, Hamstring Rehab\n'
            '• Plantar Fasciitis, Ankle Sprain, Wrist & Elbow Recovery\n'
            '• Balance & Fall Prevention, Full Body Mobility, Active Ageing\n\n'
            'Every plan follows a Pain Relief → Recovery → Strengthening progression with built-in rest days.',
        browseTarget: 'plans',
        quickReplies: [
          'Lower back plan',
          'Knee plan',
          'Posture plan',
          'Where should I start?'
        ],
      );
    }

    // ── Where to start ────────────────────────────────────────────
    if (_any(t, [
      'where should i start', 'which plan', 'recommend a plan',
      'what should i do', 'how do i start', 'new here', 'getting started',
    ])) {
      return const KnowledgeMatch(
        message:
            'The best starting point depends on your specific concern. For general mobility and no prior experience, the Full Body Mobility Starter (7 days) is ideal — it covers every major joint with zero equipment.\n\n'
            'If you have a specific pain area, tell me and I\'ll recommend the most appropriate plan and exercises.',
        planId: 'full_body_7d',
        quickReplies: [
          'I have back pain',
          'I have knee pain',
          'I have neck pain',
          'Show me all plans'
        ],
      );
    }

    // ── AREA: Neck ────────────────────────────────────────────────
    if (_any(t, [
      'neck exercise', 'exercise for neck', 'neck stretch',
      'neck mobility', 'stiff neck', 'neck stiffness', 'cervical',
    ])) {
      return const KnowledgeMatch(
        message:
            'For neck pain and stiffness, the clinical priority is restoring mobility first, then strengthening the deep cervical flexors. Begin with the lateral tilt and chin tucks — these two exercises alone resolve the majority of desk-related neck pain when done consistently.',
        exerciseIds: [
          'neck_tilt', 'chin_tucks', 'neck_rotation', 'levator_stretch'
        ],
        planId: 'neck_desk_14d',
        quickReplies: [
          'Neck pain plan',
          'Upper back exercises',
          'Shoulder exercises',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Shoulder ────────────────────────────────────────────
    if (_any(t, [
      'shoulder exercise', 'exercise for shoulder', 'shoulder stretch',
      'shoulder mobility', 'rotator cuff', 'shoulder impingement',
      'shoulder pain exercise',
    ])) {
      return const KnowledgeMatch(
        message:
            'Shoulder rehabilitation requires a precise balance of mobility and scapular stabilisation. Start with pendulum swings to reduce guarding and pain, then progress to rotator cuff and mid-back strengthening. Avoid heavy overhead work until full range of motion is restored.',
        exerciseIds: [
          'pendulum_swings', 'cross_body_stretch', 'wall_angels',
          'scapular_retraction'
        ],
        planId: 'shoulder_14d',
        quickReplies: [
          'Frozen shoulder plan',
          'Neck exercises',
          'Upper back exercises',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Upper back ──────────────────────────────────────────
    if (_any(t, [
      'upper back exercise', 'thoracic exercise', 'mid back exercise',
      'thoracic mobility', 'posture exercise', 'rounded shoulder',
      'upper back stretch',
    ])) {
      return const KnowledgeMatch(
        message:
            'Thoracic mobility is the most overlooked area in self-managed rehabilitation. Restriction here directly drives neck stiffness and shoulder dysfunction. Thoracic extension over a chair back and wall angels are two of the most effective exercises in the entire library for desk workers.',
        exerciseIds: [
          'thoracic_extension', 'wall_angels', 'seated_row', 'prone_cobra'
        ],
        planId: 'posture_21d',
        quickReplies: [
          'Neck exercises',
          'Shoulder exercises',
          'Posture plan',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Lower back ──────────────────────────────────────────
    if (_any(t, [
      'lower back exercise', 'back exercise', 'back pain exercise',
      'exercise for back', 'lumbar exercise', 'back stretch',
      'exercise for lower back',
    ])) {
      return const KnowledgeMatch(
        message:
            'Lower back rehabilitation centres on two goals: decompression and stability. Begin with the knee-to-chest stretch and cat-cow for immediate pain relief, then introduce bird dog and dead bug to build the deep core stability that prevents recurrence.',
        exerciseIds: [
          'knee_chest_stretch', 'pelvic_tilts', 'bird_dog', 'dead_bug'
        ],
        planId: 'lower_back_7d',
        quickReplies: [
          'Sciatica exercises',
          'Core exercises',
          'Hip exercises',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Core ────────────────────────────────────────────────
    if (_any(t, [
      'core exercise', 'core stability', 'abs exercise',
      'abdominal exercise', 'strengthen core', 'core workout',
      'core strength',
    ])) {
      return const KnowledgeMatch(
        message:
            'The most effective core training for pain management focuses on anti-rotation and anti-extension patterns, not crunches. Bird dog and dead bug train the deep stabilisers (transversus abdominis and multifidus) that directly support the spine. Diaphragmatic breathing activates the top of the core cylinder and reduces pain sensitisation.',
        exerciseIds: [
          'bird_dog', 'dead_bug', 'plank', 'diaphragmatic_breathing'
        ],
        planId: 'hip_core_21d',
        quickReplies: [
          'Lower back exercises',
          'Hip exercises',
          'Lower back plan',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Hip ─────────────────────────────────────────────────
    if (_any(t, [
      'hip exercise', 'exercise for hip', 'hip stretch', 'hip mobility',
      'hip pain exercise', 'tight hip', 'hip flexor', 'hip stiffness',
    ])) {
      return const KnowledgeMatch(
        message:
            'Hip dysfunction is frequently an unrecognised driver of both lower back and knee pain. The hip flexors, piriformis, and gluteus medius all require targeted work. Glute bridges are the single most useful hip exercise — they strengthen the posterior chain while protecting the spine.',
        exerciseIds: [
          'hip_flexor_stretch', 'piriformis_stretch', 'glute_bridges',
          'clamshells'
        ],
        planId: 'hip_core_21d',
        quickReplies: [
          'Sciatica exercises',
          'Lower back exercises',
          'Knee exercises',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Knee ────────────────────────────────────────────────
    if (_any(t, [
      'knee exercise', 'exercise for knee', 'knee stretch',
      'knee pain exercise', 'knee rehab', 'quad exercise', 'patella',
      'knee strengthening',
    ])) {
      return const KnowledgeMatch(
        message:
            'Knee rehabilitation begins with re-establishing neuromuscular control before adding load. Quad sets and straight leg raises rebuild the quad without compressing the joint. Wall squats are introduced once initial pain settles — they\'re the most functional strengthening exercise for the knee.',
        exerciseIds: [
          'quad_sets', 'straight_leg_raise', 'wall_squats', 'hamstring_curl'
        ],
        planId: 'knee_14d',
        quickReplies: [
          'Hip exercises',
          'Ankle exercises',
          'Hamstring exercises',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Ankle ───────────────────────────────────────────────
    if (_any(t, [
      'ankle exercise', 'exercise for ankle', 'ankle stretch',
      'ankle mobility', 'ankle pain exercise', 'ankle sprain exercise',
      'foot exercise', 'ankle strengthening',
    ])) {
      return const KnowledgeMatch(
        message:
            'Ankle rehabilitation must address three components in sequence: range of motion, calf strength, and proprioception. The proprioceptive component — single-leg balance and star excursion — is the phase most people skip, and its absence is the primary cause of recurrent ankle sprains.',
        exerciseIds: [
          'ankle_circles', 'calf_raises', 'gastrocnemius_stretch',
          'single_leg_balance'
        ],
        planId: 'ankle_recovery_14d',
        quickReplies: [
          'Plantar fasciitis plan',
          'Balance exercises',
          'Knee exercises',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Hamstring ───────────────────────────────────────────
    if (_any(t, [
      'hamstring exercise', 'exercise for hamstring', 'hamstring stretch',
      'tight hamstring', 'hamstring injury', 'hamstring pain',
    ])) {
      return const KnowledgeMatch(
        message:
            'Hamstrings respond well to structured rehabilitation. The progression moves from passive stretching to active strengthening, and ultimately to eccentric loading. The Nordic Hamstring Curl is the gold-standard exercise for hamstring rehabilitation — it dramatically reduces re-injury risk through eccentric overload.',
        exerciseIds: [
          'supine_hamstring_stretch', 'seated_hamstring_stretch',
          'hamstring_curl', 'nordic_curl'
        ],
        planId: 'hamstring_14d',
        quickReplies: [
          'Knee exercises',
          'Hip exercises',
          'Lower back exercises',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Wrist / Elbow ───────────────────────────────────────
    if (_any(t, [
      'wrist exercise', 'elbow exercise', 'tennis elbow',
      'golfer elbow', 'carpal tunnel', 'forearm exercise', 'wrist pain',
      'elbow pain',
    ])) {
      return const KnowledgeMatch(
        message:
            'Wrist and elbow conditions share a common driver: repetitive tendon load without adequate recovery. Eccentric loading of the tendons — the wrist eccentric curl — is the most evidence-supported intervention for tennis elbow, more effective than rest or conventional stretching alone.',
        exerciseIds: [
          'wrist_flexor_stretch', 'wrist_extensor_stretch',
          'wrist_eccentric_curl', 'forearm_pronation_supination'
        ],
        planId: 'wrist_elbow_14d',
        quickReplies: [
          'Grip strengthening',
          'Shoulder exercises',
          'Wrist plan',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Balance ─────────────────────────────────────────────
    if (_any(t, [
      'balance exercise', 'fall prevention', 'improve balance',
      'proprioception', 'balance training', 'stability exercise',
      'balance and stability',
    ])) {
      return const KnowledgeMatch(
        message:
            'Balance training challenges the three systems responsible for stability: vestibular (inner ear), visual, and somatosensory (joint position sense). Progression from two-leg to single-leg to dynamic excursion challenges all three simultaneously. This type of training is essential after any lower limb injury and becomes critical from age 50 onwards.',
        exerciseIds: [
          'single_leg_balance', 'heel_to_toe_walk', 'star_excursion_balance',
          'tandem_stance'
        ],
        planId: 'balance_fall_14d',
        quickReplies: [
          'Ankle exercises',
          'Knee exercises',
          'Hip exercises',
          'When to see a doctor?'
        ],
      );
    }

    // ── AREA: Beginner ────────────────────────────────────────────
    if (_any(t, [
      'beginner exercise', 'easy exercise', 'gentle exercise',
      'starting exercise', 'new to exercise', 'simple exercise',
      'no experience', 'first time',
    ])) {
      return const KnowledgeMatch(
        message:
            'Every exercise in the beginner category is designed to be low-risk, require no equipment, and be progressable over time. Cat-cow is the most effective combined lower and upper back mobiliser. Glute bridges build posterior chain strength without spinal loading. Child\'s pose provides full-back decompression.',
        exerciseIds: [
          'cat_cow', 'pelvic_tilts', 'glute_bridges', 'childs_pose'
        ],
        planId: 'full_body_7d',
        quickReplies: [
          'Full body 7-day plan',
          'Lower back exercises',
          'Hip exercises',
          'What can you do?'
        ],
      );
    }

    // ── PLANS ─────────────────────────────────────────────────────

    if (_any(t, [
      'lower back plan', 'back pain plan', 'back pain program',
      'lower back program', '7 day back', 'back recovery'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Lower Back Pain Relief program is a 7-day progressive plan used widely in physiotherapy practice. It opens with pain-relieving stretches and mobility work, transitions to light core activation, and closes with stabilisation exercises — the clinical sequence trusted for acute and subacute lower back pain.',
        planId: 'lower_back_7d',
        quickReplies: [
          'Show me back exercises',
          'Core exercises',
          'Hip exercises',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'neck plan', 'desk worker plan', 'neck program', 'office neck',
      'neck 14', 'neck recovery'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Neck & Desk Worker Release is a 14-day program designed for screen-heavy lifestyles. It addresses the triad that comes with prolonged sitting: cervical stiffness, tight chest, and weak postural muscles. Approximately 12–25 minutes per day, no equipment needed.',
        planId: 'neck_desk_14d',
        quickReplies: [
          'Neck exercises',
          'Shoulder exercises',
          'Posture plan',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'sciatica plan', 'sciatica program', 'sciatic nerve plan', 'sciatica'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Sciatica Relief Program targets the three drivers of sciatic nerve compression: piriformis tightness, restricted hip mobility, and insufficient lumbar stabilisation. The 7-day structure provides immediate decompression exercises while building the deep core support needed to prevent recurrence.',
        planId: 'sciatica_7d',
        quickReplies: [
          'Hip exercises',
          'Lower back exercises',
          'Core exercises',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'knee plan', 'knee program', 'knee rehab plan', 'knee 14',
      'knee recovery', 'knee strengthening plan'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Knee Strengthening program is a 14-day progressive protocol suited for sports injuries, patellofemoral pain, and early osteoarthritis. It rebuilds quadriceps and hamstring balance without loading the joint surface in painful ranges — the safest evidence-based approach to knee rehabilitation.',
        planId: 'knee_14d',
        quickReplies: [
          'Knee exercises',
          'Hip exercises',
          'Ankle exercises',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'posture plan', 'posture program', 'posture correction plan',
      'posture 21', 'fix posture', 'improve posture'
    ])) {
      return const KnowledgeMatch(
        message:
            'The 21-day Posture Correction program is the most comprehensive in the library. It resolves all three components of sitting-induced posture dysfunction: chest tightness, upper back weakness, and deconditioned deep cervical flexors. The longest plan, but also the most transformative for chronic desk workers.',
        planId: 'posture_21d',
        quickReplies: [
          'Posture exercises',
          'Neck exercises',
          'Shoulder plan',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'shoulder plan', 'rotator cuff plan', 'shoulder program',
      'shoulder 14', 'shoulder rehab plan'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Shoulder & Rotator Cuff program rehabilitates shoulder impingement and rotator cuff strain over 14 days. The progression from pendulum work through range-of-motion drills to scapular stabilisation matches the standard physiotherapy treatment protocol for shoulder pain.',
        planId: 'shoulder_14d',
        quickReplies: [
          'Shoulder exercises',
          'Frozen shoulder plan',
          'Neck plan',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'hip plan', 'core plan', 'hip core', 'hip program',
      'hip flexor plan', 'hip 21'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Hip Flexor & Core Release is a 21-day program for the sitting epidemic. It progressively unlocks tight hip flexors and piriformis, then builds deep core and glute strength — the most effective combination for eliminating chronic hip and lower back discomfort.',
        planId: 'hip_core_21d',
        quickReplies: [
          'Hip exercises',
          'Core exercises',
          'Lower back plan',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'full body plan', 'beginner plan', 'starter plan', 'full body 7',
      'start plan', 'first plan', 'no experience plan'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Full Body Mobility Starter is the recommended entry point for anyone new to structured exercise or returning after a break. It covers every major joint over 7 days, requires no equipment and no experience, and takes 12–25 minutes per session.',
        planId: 'full_body_7d',
        quickReplies: [
          'All exercises',
          'Lower back plan',
          'Posture plan',
          'What can you do?'
        ],
      );
    }

    if (_any(t, [
      'plantar fasciitis plan', 'plantar fasciitis program',
      'heel pain plan', 'plantar', 'foot pain plan'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Plantar Fasciitis Recovery plan attacks the three drivers: tight gastrocnemius, tight soleus, and weak foot intrinsics. Eccentric calf loading is introduced in week 2 — this is the most evidence-supported single intervention for plantar fasciitis, with research consistently showing it outperforms orthotics and rest alone.',
        planId: 'plantar_fasciitis_14d',
        quickReplies: [
          'Ankle exercises',
          'Balance exercises',
          'Ankle plan',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'ankle plan', 'ankle sprain plan', 'ankle rehab plan', 'ankle program'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Ankle Sprain Recovery plan follows the evidence-based rehabilitation sequence: early mobility restoration, calf strengthening, and proprioceptive training. Most people stop after the pain resolves and skip the proprioception phase — this is why recurrent ankle sprains are so common.',
        planId: 'ankle_recovery_14d',
        quickReplies: [
          'Ankle exercises',
          'Balance exercises',
          'Plantar fasciitis plan',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'hamstring plan', 'hamstring program', 'hamstring rehab plan'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Hamstring Rehabilitation plan is structured around eccentric loading — the Nordic Hamstring Curl — which has the strongest evidence base of any exercise for hamstring injury management. The 14-day progression builds from passive stretching through active strengthening before introducing the eccentric phase.',
        planId: 'hamstring_14d',
        quickReplies: [
          'Hamstring exercises',
          'Knee exercises',
          'Hip exercises',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'wrist plan', 'elbow plan', 'tennis elbow plan', 'wrist program',
      'elbow program', 'forearm plan'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Wrist & Elbow Recovery program uses evidence-based eccentric tendon loading to resolve tennis elbow, golfer\'s elbow, and wrist pain. The eccentric loading phase in days 5–14 consistently outperforms conventional stretching and rest in clinical trials for lateral epicondylitis.',
        planId: 'wrist_elbow_14d',
        quickReplies: [
          'Wrist exercises',
          'Shoulder exercises',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'frozen shoulder plan', 'frozen shoulder program',
      'adhesive capsulitis', 'shoulder stiffness plan'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Frozen Shoulder Rehabilitation program is carefully paced over 21 days, beginning with gravity-assisted pendulum work to reduce pain and capsular guarding, progressing to active range-of-motion, and finishing with scapular stabilisation. Patience with each phase is critical — rushing frozen shoulder rehabilitation typically extends recovery.',
        planId: 'frozen_shoulder_21d',
        quickReplies: [
          'Shoulder exercises',
          'Shoulder plan',
          'Neck exercises',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'balance plan', 'fall prevention plan', 'balance program',
      'fall prevention program', 'balance fall'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Balance & Fall Prevention program systematically challenges all three balance systems over 14 days. It\'s designed for older adults, post-injury rehabilitation, and anyone wanting to significantly reduce fall risk. Proprioceptive training at this intensity can reduce fall incidence by up to 40% in older adults.',
        planId: 'balance_fall_14d',
        quickReplies: [
          'Balance exercises',
          'Ankle exercises',
          'Knee exercises',
          'When to see a doctor?'
        ],
      );
    }

    if (_any(t, [
      'ageing plan', 'joint health plan', 'active ageing',
      'older adult', 'senior plan', 'over 50', '50 plus'
    ])) {
      return const KnowledgeMatch(
        message:
            'The Active Ageing & Joint Health program is a 21-day full-body protocol for adults 50+ or anyone managing multiple joint conditions. Every exercise is low-impact with built-in rest days, and the progression covers neck, shoulders, back, hips, knees, and ankles — the most complete plan in the library.',
        planId: 'active_ageing_21d',
        quickReplies: [
          'Balance plan',
          'Full body exercises',
          'Full body plan',
          'When to see a doctor?'
        ],
      );
    }

    return null;
  }

  static bool _any(String text, List<String> keywords) =>
      keywords.any((k) => text.contains(k));
}
