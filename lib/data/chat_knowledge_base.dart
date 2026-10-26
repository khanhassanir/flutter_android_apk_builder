class ChatIntent {
  final String id;
  final List<List<String>> triggers;
  final int priority;
  final String response;
  final List<String> quickReplies;
  final List<String> exerciseIds;
  final String? planId;
  final String? browseTarget; // 'exercises' | 'plans' | null

  const ChatIntent({
    required this.id,
    required this.triggers,
    this.priority = 1,
    required this.response,
    this.quickReplies = const [],
    this.exerciseIds = const [],
    this.planId,
    this.browseTarget,
  });
}

const List<ChatIntent> chatKnowledgeBase = [

  // ── GREETINGS ─────────────────────────────────────────────────────

  ChatIntent(
    id: 'greeting_hello',
    triggers: [['hello'], ['hi there'], ['hey'], ['good morning'], ['good evening'], ['howdy']],
    priority: 1,
    response: "Hey! I'm your PhysioAI assistant — think of me as a knowledgeable physio friend available 24/7.\n\nI can help you understand your pain, explain exercises step-by-step, suggest recovery plans, and give you expert tips. Everything works offline — no internet, no charges.\n\nWhat's bothering you today?",
    quickReplies: ['I have back pain', 'Neck and shoulder pain', 'Knee pain', 'What can you do?'],
  ),

  ChatIntent(
    id: 'greeting_how_are_you',
    triggers: [['how are you'], ['how r u'], ['how do you do'], ['you good']],
    priority: 1,
    response: "I'm here and ready to help! I'm your PhysioAI assistant — always on, completely free, no appointments needed.\n\nI have detailed knowledge on pain conditions, exercises, recovery plans, posture, sleep positions, and general physiotherapy advice. What can I help you with?",
    quickReplies: ['Back pain', 'Neck pain', 'Shoulder pain', 'General tips'],
  ),

  ChatIntent(
    id: 'greeting_what_can_you_do',
    triggers: [['what can you do'], ['what do you know'], ['help me'], ['what are you'], ['capabilities'], ['tell me about yourself'], ['how do you work']],
    priority: 1,
    response: "Great question! Here is everything I can do — completely free and offline:\n\n• Explain what your pain likely means based on your symptoms\n• Describe specific exercises with full step-by-step technique\n• Suggest the right recovery plan for your condition\n• Give physio tips on posture, sleep, ice vs heat, and more\n• Answer questions about physiotherapy, exercise frequency, and lifestyle\n\nI can't replace a hands-on physiotherapist for complex cases, but I can give you expert guidance to get started. What would you like to know?",
    quickReplies: ['I have back pain', 'Suggest exercises', 'Show me plans', 'Posture tips'],
  ),

  ChatIntent(
    id: 'greeting_thanks',
    triggers: [['thank you'], ['thanks'], ['thx'], ['great advice'], ['helpful'], ['appreciate'], ['that helped']],
    priority: 1,
    response: "You're welcome! Remember, consistency is the secret in physiotherapy — small daily efforts add up to big, lasting results.\n\nDon't stop when the pain eases — that's exactly when building strength matters most. Is there anything else I can help you with?",
    quickReplies: ['More tips', 'Back pain', 'Show exercises', 'Recovery plans'],
  ),

  // ── LOWER BACK ────────────────────────────────────────────────────

  ChatIntent(
    id: 'lower_back_sciatica',
    triggers: [
      ['sciatica'],
      ['sciatic nerve'],
      ['pain down', 'leg'],
      ['shooting', 'leg'],
      ['radiating', 'leg'],
      ['pain', 'buttock', 'leg'],
    ],
    priority: 4,
    response: "Sciatica is caused by irritation or compression of the sciatic nerve — it runs from your lower back through your hips and buttocks and down each leg. The shooting or burning pain you feel is the nerve talking.\n\nKey things to know:\n• Avoid prolonged sitting — take a 2-minute walk every 30 minutes\n• Sleep on your side with a pillow between your knees\n• Gentle movement is better than bed rest — the nerve needs to glide freely\n• Avoid bending forward AND twisting simultaneously\n\nThe Bird Dog and Dead Bug are excellent for stabilising the spine without aggravating the nerve. The Sciatica 7-Day plan is designed exactly for this.",
    quickReplies: ['Bird Dog exercise', 'Dead Bug exercise', 'Sleep position for sciatica', 'Ice or heat?'],
    exerciseIds: ['bird_dog', 'dead_bug', 'knee_chest_stretch'],
    planId: 'sciatica_7d',
  ),

  ChatIntent(
    id: 'lower_back_sharp',
    triggers: [
      ['lower back', 'sharp'],
      ['lumbar', 'sharp'],
      ['lower back', 'stabbing'],
      ['lower back', 'acute'],
      ['back', 'sudden', 'pain'],
    ],
    priority: 3,
    response: "Sharp lower back pain that comes on suddenly usually points to muscle spasm or disc irritation. The good news — most acute back pain, even when severe, resolves within 2–4 weeks with the right approach.\n\nImmediate steps:\n• Ice for the first 48 hours (15 min on, 45 min off)\n• Avoid sudden twisting or bending forward\n• Gentle movement is better than complete rest\n• Sleep on your side with knees slightly bent\n\nStart with Pelvic Tilts and Knee-to-Chest Stretches — they calm the muscles without stressing the disc. If pain travels down your leg or is severe, see a physiotherapist.",
    quickReplies: ['Ice or heat?', 'Can I exercise with pain?', 'Pelvic tilt exercise', 'When to see a doctor'],
    exerciseIds: ['pelvic_tilts', 'knee_chest_stretch', 'childs_pose'],
    planId: 'lower_back_7d',
  ),

  ChatIntent(
    id: 'lower_back_stiffness',
    triggers: [
      ['lower back', 'stiff'],
      ['lumbar', 'stiff'],
      ['lower back', 'tight'],
      ['lower back', 'morning'],
      ['back stiff', 'morning'],
      ['back stiffness'],
    ],
    priority: 3,
    response: "Morning stiffness or general tightness in the lower back is one of the most common and most fixable complaints. It's usually caused by muscle tightness, poor sleep posture, or prolonged sitting that weakens the deep stabilising muscles.\n\nWhat helps most:\n• Do 5 minutes of gentle movement before getting out of bed\n• Cat-Cow stretches are gold for morning stiffness — 10 slow reps on waking\n• Avoid sitting for more than 45 minutes without a break\n• A warm shower before stretching makes muscles far more receptive\n\nThe 7-Day Lower Back plan starts exactly here and progressively builds the core strength that prevents stiffness from returning.",
    quickReplies: ['How to do Cat-Cow', 'Morning back routine', 'Core exercises', 'Start plan'],
    exerciseIds: ['cat_cow', 'pelvic_tilts', 'childs_pose'],
    planId: 'lower_back_7d',
  ),

  ChatIntent(
    id: 'lower_back_chronic',
    triggers: [
      ['lower back', 'chronic'],
      ['lower back', 'months'],
      ['lower back', 'years'],
      ['chronic back'],
      ['back pain', 'long time'],
      ['back pain', 'always'],
    ],
    priority: 3,
    response: "Chronic lower back pain (lasting more than 3 months) can feel defeating — but it responds excellently to the right exercise approach. Research consistently shows movement and progressive strengthening outperform medication and rest alone.\n\nThe chronic pain cycle:\nPain → avoid movement → muscles weaken → more pain → repeat\nBreaking this cycle requires gradual, consistent exercise.\n\nFocus areas:\n• Core stability: Bird Dog, Dead Bug\n• Hip flexibility: Hip Flexor Stretch, Piriformis Stretch\n• Glute strength: Glute Bridges\n• Daily walking — even 20 minutes improves circulation and reduces pain signalling\n\nThe 21-Day Posture & Core plan is ideal for chronic sufferers — phased and progressive.",
    quickReplies: ['Bird Dog exercise', 'Core strengthening', 'Walking and back pain', 'Posture tips'],
    exerciseIds: ['bird_dog', 'dead_bug', 'glute_bridges', 'hip_flexor_stretch'],
    planId: 'posture_21d',
  ),

  ChatIntent(
    id: 'lower_back_sitting',
    triggers: [
      ['lower back', 'sitting'],
      ['lower back', 'desk'],
      ['lower back', 'office'],
      ['lower back', 'computer'],
      ['back pain', 'sitting'],
      ['back pain', 'work'],
    ],
    priority: 3,
    response: "Sitting is one of the worst things for your back. Extended sitting compresses spinal discs, tightens hip flexors, and switches off your glutes — the three main contributors to desk-worker back pain.\n\nFix your setup:\n• Feet flat on floor, knees at 90 degrees\n• Monitor at eye level — top third of screen\n• Small rolled towel or lumbar support at the small of your back\n• Sit back fully in your chair, don't perch on the edge\n\nFix your habits:\n• Stand or walk every 30–45 minutes (set a phone timer — it actually works)\n• Do 10 Pelvic Tilts every hour at your desk — no one will notice\n• Consider a standing desk that lets you alternate\n\nEven small changes here produce dramatic results within weeks.",
    quickReplies: ['Desk ergonomics tips', 'Exercises at my desk', 'Hip flexor stretch', 'Start a plan'],
    exerciseIds: ['pelvic_tilts', 'hip_flexor_stretch', 'cat_cow'],
  ),

  ChatIntent(
    id: 'lower_back_general',
    triggers: [['lower back'], ['lumbar'], ['lumbago'], ['low back'], ['back pain']],
    priority: 1,
    response: "Lower back pain is the world's number one musculoskeletal complaint — so you're definitely not alone. It can range from a dull ache to sharp, debilitating pain, and the causes vary widely.\n\nCommon causes:\n• Muscle strain or spasm\n• Poor posture accumulated over time\n• Disc issues (bulge or herniation)\n• Tight hip flexors from prolonged sitting\n• Weak core muscles that can't support the spine\n\nCould you tell me more? For example:\n• Is it sharp, dull, stiff, or burning?\n• Does it radiate down your leg?\n• How long have you had it?\n\nThe more detail, the more specific my advice can be!",
    quickReplies: ['Sharp lower back pain', 'Stiffness in morning', 'Pain for months', 'Pain when sitting'],
  ),

  // ── NECK ──────────────────────────────────────────────────────────

  ChatIntent(
    id: 'neck_tech',
    triggers: [
      ['tech neck'],
      ['text neck'],
      ['neck', 'phone'],
      ['neck', 'computer'],
      ['neck', 'screen'],
      ['neck', 'desk'],
      ['neck', 'laptop'],
    ],
    priority: 3,
    response: "Tech neck is a modern epidemic. Holding your head forward over a screen puts up to 60 lbs of extra force on your cervical spine. For every inch your head moves forward, the load roughly doubles.\n\nThe fix:\n• Position your phone or screen at eye level — most people look 30–40 degrees downward\n• Every 30 minutes, do 10 chin tucks (draw chin straight back, not down)\n• Strengthen your deep neck flexors — the equivalent of core muscles for your neck\n• Stretch your chest — tight pecs pull shoulders forward, which pulls your head with them\n\nChin Tucks are the single most effective exercise for tech neck. Three sets of 10 throughout the day dramatically changes your posture within 4–6 weeks.",
    quickReplies: ['How to do chin tucks', 'Neck exercises', 'Desk setup tips', 'Shoulder pain too'],
    exerciseIds: ['chin_tucks', 'neck_rotation', 'levator_stretch'],
    planId: 'neck_desk_14d',
  ),

  ChatIntent(
    id: 'neck_headache',
    triggers: [
      ['neck', 'headache'],
      ['cervicogenic'],
      ['neck', 'head pain'],
      ['headache', 'neck'],
      ['base of skull'],
    ],
    priority: 4,
    response: "What you're likely experiencing is a cervicogenic headache — headaches that originate from the neck, not the head itself. They're caused by tension in the suboccipital muscles (small muscles at the base of your skull) that compress nerves and refer pain upward.\n\nHow to identify it:\n• Pain starts at the base of your skull and spreads toward the forehead or temples\n• Neck movement makes it worse\n• Pain often matches whichever side of your neck is stiffest\n\nWhat helps:\n• Chin tucks decompress the upper cervical spine — do them often\n• Gentle neck rotation — slow and controlled, not forced\n• Improve your sitting posture — most cervicogenic headaches are posture-driven\n\nImportant: if a headache is sudden and the worst of your life, seek medical help immediately.",
    quickReplies: ['Chin tuck exercise', 'Posture for neck pain', 'Neck stiffness', 'When to see a doctor'],
    exerciseIds: ['chin_tucks', 'neck_rotation', 'levator_stretch'],
  ),

  ChatIntent(
    id: 'neck_nerve',
    triggers: [
      ['neck', 'arm'],
      ['neck', 'radiating'],
      ['neck', 'tingling'],
      ['neck', 'numbness'],
      ['cervical radiculopathy'],
      ['neck', 'fingers', 'pain'],
    ],
    priority: 4,
    response: "Pain or tingling running from your neck into your arm suggests cervical radiculopathy — a compressed or irritated nerve root in your cervical spine. Each disc level affects a different part of the arm.\n\nCommon patterns:\n• C5 nerve: outer shoulder and upper arm\n• C6 nerve: thumb and index finger\n• C7 nerve: middle finger\n• C8 nerve: ring and little finger\n\nWhat to do:\n• Avoid positions that aggravate it — typically head turned toward the painful side\n• Gentle chin tucks can create space for the nerve root\n• Avoid heavy lifting or overhead reaching for now\n\nImportant: if you have weakness in your hand, clumsiness, or symptoms in both arms or legs simultaneously — see a doctor promptly. This needs proper assessment.",
    quickReplies: ['Chin tuck exercise', 'When to see a doctor', 'Shoulder pain too', 'Numbness concerns'],
    exerciseIds: ['chin_tucks', 'neck_rotation'],
  ),

  ChatIntent(
    id: 'neck_morning',
    triggers: [
      ['neck', 'morning'],
      ['neck', 'waking up'],
      ['neck', 'after sleep'],
      ['woke up', 'neck'],
      ['neck', 'pillow'],
      ['neck stiff', 'morning'],
    ],
    priority: 3,
    response: "Waking up with a stiff or painful neck is almost always caused by sleeping in an awkward position — your neck muscles stay in a shortened or lengthened position for hours, causing spasm or stiffness.\n\nBest sleep positions for neck:\n• Back: with a contour pillow that supports the natural neck curve\n• Side: pillow thick enough to keep your ear directly over your shoulder\n• Avoid stomach sleeping — it forces neck rotation for the entire night\n\nImmediate morning relief:\n• Before getting up: 5 gentle neck rotations each direction\n• Chin tucks: 10 reps (draw chin straight back, hold 5 seconds each)\n• Warm shower on your neck before any stretching — heat first, always\n\nIf it keeps happening, your pillow is likely the culprit. A proper contour cervical pillow makes a significant difference.",
    quickReplies: ['Neck exercises', 'Best sleeping position', 'Tech neck tips', 'Neck pain all day'],
    exerciseIds: ['neck_rotation', 'chin_tucks', 'levator_stretch'],
  ),

  ChatIntent(
    id: 'neck_general',
    triggers: [['neck pain'], ['neck ache'], ['sore neck'], ['cervical pain'], ['neck hurts'], ['stiff neck']],
    priority: 1,
    response: "Neck pain is incredibly common — about 70% of people experience it at some point. The neck supports your 5 kg head all day and takes on a lot of postural stress.\n\nCould you tell me more about your neck pain?\n• Where exactly? (base of skull, mid-neck, into shoulder blade?)\n• Any tingling or pain into your arms or hands?\n• Is it worse in the morning or builds through the day?\n• Do you work at a computer or look at a phone frequently?\n\nThe more detail you give me, the more targeted my advice can be!",
    quickReplies: ['Computer-related neck pain', 'Morning neck stiffness', 'Neck and headache', 'Pain into my arm'],
  ),

  // ── SHOULDERS ─────────────────────────────────────────────────────

  ChatIntent(
    id: 'shoulder_frozen',
    triggers: [
      ['frozen shoulder'],
      ['shoulder', 'frozen'],
      ["shoulder", "can't raise"],
      ['shoulder', "can't lift arm"],
      ['adhesive capsulitis'],
      ['shoulder', 'stiff', 'months'],
    ],
    priority: 4,
    response: "Frozen shoulder (adhesive capsulitis) occurs when the shoulder joint's capsule becomes inflamed and thickened, restricting movement in all directions. It goes through three stages:\n\n1. Freezing (3–9 months): Gradually increasing pain and stiffness\n2. Frozen (9–12 months): Pain eases but stiffness remains severe\n3. Thawing (12–18 months): Gradual return of movement\n\nTreatment approach:\n• Gentle range-of-motion exercises daily — never force the movement\n• Pendulum Swings are your best friend — let gravity do the work, not muscle effort\n• Heat before exercises, ice after if irritated\n• Consistent gentle movement beats complete rest — the capsule needs stimulation\n\nThe 14-Day Shoulder Rehabilitation plan follows the correct protocol for this.",
    quickReplies: ['Pendulum swing exercise', 'How long to recover?', 'Ice or heat?', 'Shoulder exercises'],
    exerciseIds: ['pendulum_swings', 'cross_body_stretch', 'door_chest_stretch'],
    planId: 'shoulder_14d',
  ),

  ChatIntent(
    id: 'shoulder_rotator',
    triggers: [
      ['rotator cuff'],
      ['shoulder', 'rotator'],
      ['shoulder', 'tear'],
      ['shoulder', 'torn'],
      ['shoulder weakness'],
    ],
    priority: 3,
    response: "The rotator cuff is a group of four muscles and tendons that stabilise your shoulder joint. Strains are common from overhead work, sports, or awkward catches.\n\nSigns of rotator cuff strain:\n• Pain reaching overhead or behind your back\n• Weakness when lifting your arm sideways\n• Night pain, especially lying on the affected shoulder\n• A painful arc — lifting the arm between roughly 60 and 120 degrees causes pain\n\nConservative treatment for strains:\n• Avoid aggravating overhead activities for 1–2 weeks\n• Strengthen the surrounding shoulder blade muscles — Wall Angels are essential\n• Postural correction reduces impingement on the already-stressed tendons\n\nNote: if you suspect a complete tear (sudden significant weakness after an injury), get imaging done — this may need specialist review beyond exercise.",
    quickReplies: ['Wall angel exercise', 'Shoulder impingement', 'Sleeping with shoulder pain', 'Start shoulder plan'],
    exerciseIds: ['wall_angels', 'shoulder_rolls', 'cross_body_stretch'],
    planId: 'shoulder_14d',
  ),

  ChatIntent(
    id: 'shoulder_impingement',
    triggers: [
      ['shoulder', 'clicking'],
      ['shoulder', 'snapping'],
      ['shoulder', 'catching'],
      ['shoulder impingement'],
      ['shoulder', 'pinching'],
      ['shoulder', 'overhead'],
    ],
    priority: 3,
    response: "Shoulder clicking, snapping, or catching with pain usually indicates shoulder impingement — where tendons get pinched between bones during movement, especially overhead. It's very common and very treatable.\n\nWhy it happens:\n• Poor posture (rounded shoulders) narrows the subacromial space where tendons run\n• Weak rotator cuff muscles don't keep the ball centred in the socket\n• Tight chest muscles pull the shoulder blade forward, reducing the space further\n\nThe fix:\n• Open your chest — stretch the pectoralis minor daily\n• Strengthen your lower trapezius and serratus anterior (Wall Angels are perfect for both)\n• Correct your posture — this alone often eliminates impingement\n• Avoid overhead lifting until pain reduces\n\nThis condition responds brilliantly to exercise therapy — most cases resolve in 6–12 weeks.",
    quickReplies: ['Wall angel exercise', 'Posture correction', 'Chest stretch', 'Rotator cuff'],
    exerciseIds: ['wall_angels', 'shoulder_rolls', 'door_chest_stretch'],
  ),

  ChatIntent(
    id: 'shoulder_sleep',
    triggers: [
      ['shoulder', 'sleeping'],
      ['shoulder', 'at night'],
      ['shoulder pain', 'night'],
      ['shoulder', 'lying down'],
      ['shoulder', 'bed'],
    ],
    priority: 3,
    response: "Shoulder pain at night — especially when lying on the affected shoulder — is very common and can severely disrupt sleep. Compression of the shoulder joint in that position aggravates bursitis or rotator cuff issues.\n\nSleeping strategies:\n• Sleep on the unaffected side with a pillow in front to hug — prevents rolling over\n• If you must sleep on the bad side, place a folded pillow under your ribs to slightly unload the shoulder\n• Back sleeping: place a thin pillow under the affected arm for support\n• Avoid sleeping with your arm above your head — this closes the subacromial space\n\nDaytime tip: shoulder muscles tighten throughout the day and express it at night. Five minutes of gentle shoulder rolls and pendulum swings before bed significantly reduces night pain.",
    quickReplies: ['Shoulder exercises', 'Frozen shoulder', 'Posture and shoulder', 'Rotator cuff'],
    exerciseIds: ['shoulder_rolls', 'pendulum_swings', 'cross_body_stretch'],
  ),

  ChatIntent(
    id: 'shoulder_general',
    triggers: [['shoulder pain'], ['shoulder ache'], ['sore shoulder'], ['shoulder hurts'], ['my shoulder']],
    priority: 1,
    response: "Shoulder pain is complex because the shoulder is the most mobile joint in the body — which means many structures can be involved. The good news is most shoulder pain responds very well to targeted exercise.\n\nCould you tell me more?\n• Is the pain sharp, dull, or aching?\n• Any clicking, catching, or snapping?\n• Is it worse overhead, behind your back, or at night?\n• Did it start after an injury, or come on gradually?\n\nThat will help me give you much more specific and useful advice!",
    quickReplies: ['Frozen shoulder', 'Clicking shoulder', 'Night pain', "Can't raise arm", 'Rotator cuff'],
  ),

  // ── UPPER BACK ────────────────────────────────────────────────────

  ChatIntent(
    id: 'upper_back_posture',
    triggers: [
      ['upper back', 'posture'],
      ['upper back', 'hunching'],
      ['upper back', 'slouch'],
      ['thoracic', 'posture'],
      ['kyphosis'],
      ['rounded', 'back'],
      ['hunchback'],
    ],
    priority: 3,
    response: "Rounded upper back (thoracic kyphosis) is almost universal in people who sit at desks. The thoracic spine naturally wants to extend and rotate, but years of flexed sitting trains it to stay rounded.\n\nConsequences of poor thoracic posture:\n• Upper back pain and chronic muscle tension\n• Shoulder impingement (rounding closes the shoulder space)\n• Cervicogenic headaches\n• Reduced breathing capacity — your ribs can't expand fully\n\nFix it:\n• Thoracic Extension over a foam roller or rolled towel — counteracts hours of flexion\n• Wall Angels reset your shoulder blade positioning and posture muscles\n• Open your chest — 30-second doorway stretch 3 times per day\n• Strengthen your lower trapezius — it retracts and depresses the shoulder blades\n\nPosture doesn't change overnight, but 3–4 weeks of consistent targeted work produces dramatic results.",
    quickReplies: ['Thoracic extension exercise', 'Wall angel exercise', 'Desk posture tips', 'Upper back pain'],
    exerciseIds: ['thoracic_extension', 'wall_angels', 'cat_cow'],
    planId: 'posture_21d',
  ),

  ChatIntent(
    id: 'upper_back_desk',
    triggers: [
      ['upper back', 'desk'],
      ['upper back', 'computer'],
      ['upper back', 'sitting'],
      ['thoracic', 'sitting'],
      ['mid back', 'desk'],
      ['between shoulder blades', 'sitting'],
    ],
    priority: 3,
    response: "Upper back pain from desk work is almost always a posture-and-muscle-fatigue combination. Hours of forward reaching to a keyboard shortens chest muscles and overstretches upper back muscles until they fatigue and ache.\n\nDesk ergonomics fix:\n• Monitor: arm's length away, at eye level, no glare\n• Keyboard: elbows at 90 degrees, forearms parallel to desk, no reaching\n• Chair: sit fully back so your whole back is supported, not just your lower back\n• Take a posture break every 30 minutes — stand up, squeeze your shoulder blades together for 5 seconds\n\nKey exercises:\n• Cat-Cow: restores thoracic mobility lost from sitting\n• Wall Angels: resets scapular muscle function\n• Thoracic Extension: the single best counter to desk flexion\n\nEven 5 minutes of these every few hours dramatically reduces desk-related upper back pain.",
    quickReplies: ['Thoracic extension', 'Cat-Cow exercise', 'Posture fix', 'Neck pain too'],
    exerciseIds: ['cat_cow', 'thoracic_extension', 'wall_angels'],
  ),

  ChatIntent(
    id: 'upper_back_sharp',
    triggers: [
      ['upper back', 'sharp'],
      ['upper back', 'spasm'],
      ['thoracic', 'sharp'],
      ['mid back', 'sharp'],
      ['upper back', 'sudden'],
      ['thoracic', 'spasm'],
    ],
    priority: 3,
    response: "Sharp upper back pain or spasm is usually a sudden muscle overload — a wrong movement, awkward reach, or even a forceful sneeze. The thoracic spine is well protected by the rib cage, so disc issues are less common here than in the lower back.\n\nImmediate management:\n• Ice for the first 24–48 hours if it came on suddenly\n• Gentle movement — avoid staying completely still, which increases stiffness\n• Child's Pose provides gentle spinal traction and is usually very relieving\n• Slow, deep diaphragmatic breaths help the intercostal and paraspinal muscles relax\n\nImportant: if the pain is very one-sided and feels like it wraps around your ribcage (like a band), see a doctor — this can occasionally indicate a rib stress fracture or (rarely) an internal issue that needs ruling out.",
    quickReplies: ["Child's Pose exercise", 'Ice or heat?', 'Upper back posture', 'When to see a doctor'],
    exerciseIds: ['childs_pose', 'cat_cow', 'thoracic_extension'],
  ),

  ChatIntent(
    id: 'upper_back_general',
    triggers: [['upper back'], ['thoracic pain'], ['mid back'], ['between shoulder blades'], ['rhomboid']],
    priority: 1,
    response: "Upper back pain often gets overlooked — it sits between the neck and lower back and is usually posture-related. The thoracic spine is designed for rotation and extension, but prolonged sitting robs it of this mobility.\n\nMost common causes:\n• Postural strain from desk work or phone use\n• Tight chest muscles pulling the upper back into tension\n• Trigger points (knots) in the rhomboids and trapezius\n• Thoracic disc issues (less common)\n\nCould you describe it more?\n• Is it between your shoulder blades, or more central?\n• Is it a constant ache or does movement trigger it?\n• Do you work at a desk?",
    quickReplies: ['Upper back + posture', 'Sharp upper back pain', 'Desk-related upper back', 'Thoracic exercises'],
  ),

  // ── HIPS ──────────────────────────────────────────────────────────

  ChatIntent(
    id: 'hip_flexor',
    triggers: [
      ['hip flexor'],
      ['hip', 'tight'],
      ['hip', 'tightness'],
      ['groin', 'tight'],
      ['psoas'],
      ['front of hip'],
    ],
    priority: 3,
    response: "Tight hip flexors are epidemic in modern life — sitting shortens the iliopsoas and rectus femoris all day long. This tightness tilts the pelvis forward (anterior pelvic tilt), which directly creates and perpetuates lower back pain.\n\nSigns of tight hip flexors:\n• Lower back pain that worsens when standing or walking\n• Your belly sticks out even at a healthy weight\n• Pain or tightness at the front of the hip when walking\n• Difficulty fully extending the hip when walking\n\nHow to fix them:\n• Hip Flexor Stretch in the kneeling lunge position: hold 45–60 seconds, 3 sets each side\n• Strengthen your glutes simultaneously — they are the direct antagonist\n• Stand more — even 30 extra minutes of standing per day reduces tightness\n\nConsistent daily stretching for 4–6 weeks produces significant, lasting improvement.",
    quickReplies: ['Hip flexor stretch exercise', 'Glute exercises', 'Lower back pain connection', 'Hip exercises'],
    exerciseIds: ['hip_flexor_stretch', 'glute_bridges', 'hip_circles'],
  ),

  ChatIntent(
    id: 'hip_arthritis',
    triggers: [
      ['hip', 'arthritis'],
      ['hip osteoarthritis'],
      ['hip', 'arthritic'],
      ['hip', 'degenerat'],
      ['hip', 'old'],
    ],
    priority: 3,
    response: "Hip osteoarthritis is very common, especially after 50 — but 'bone on bone' does not mean you're out of options. Exercise is consistently shown to be more effective than most medications for hip OA, and often delays or avoids the need for replacement surgery.\n\nKey principles:\n• Low-impact movement is your friend: walking, swimming, cycling\n• Avoid high-impact: running on hard surfaces, jumping\n• Strengthen the glutes and hip abductors — they take load off the joint\n• Every 1 kg of weight lost removes 4 kg of force from your hip joint\n\nBest exercises:\n• Glute Bridges: strengthen without joint compression\n• Hip Circles: maintain range of motion\n• Piriformis Stretch: relieve surrounding muscle tension\n\nStart gently and build — the joint needs consistent movement, not rest.",
    quickReplies: ['Hip exercises', 'Walking with hip pain', 'Swimming for hip pain', 'Hip and core plan'],
    exerciseIds: ['glute_bridges', 'hip_circles', 'piriformis_stretch'],
    planId: 'hip_core_21d',
  ),

  ChatIntent(
    id: 'hip_general',
    triggers: [['hip pain'], ['hip ache'], ['hip hurts'], ['sore hip'], ['groin pain']],
    priority: 1,
    response: "Hip pain can come from several places — the joint itself, surrounding muscles, bursae, or even referred pain from the lower back or sacroiliac joint.\n\nCommon causes:\n• Hip flexor strain (front of hip)\n• Bursitis (outer hip, worse lying on that side)\n• Piriformis tightness (deep buttock pain)\n• Osteoarthritis (deep groin pain, worse in the morning)\n• Referred pain from the lower back\n\nCould you tell me:\n• Where exactly? (front, side, groin, or buttock?)\n• Is it worse in the morning or after activity?\n• Any clicking or giving way feeling?",
    quickReplies: ['Hip flexor tightness', 'Hip arthritis', 'Hip and lower back', 'Hip exercises'],
  ),

  // ── KNEES ─────────────────────────────────────────────────────────

  ChatIntent(
    id: 'knee_patella',
    triggers: [
      ['patellofemoral'],
      ["runner's knee"],
      ['knee', 'stairs'],
      ['knee', 'running'],
      ['knee', 'kneecap'],
      ['front', 'knee', 'pain'],
      ['knee', 'cinema'],
    ],
    priority: 3,
    response: "Patellofemoral pain syndrome — sometimes called runner's knee — is one of the most common knee complaints. The kneecap isn't tracking correctly in its groove, creating friction and pain.\n\nTypical pattern:\n• Pain around or behind the kneecap\n• Worse going downstairs than up\n• Worse after prolonged sitting with knees bent (the 'cinema sign' — stiffening in a movie)\n• Worse after running, squatting, or kneeling\n\nThe root cause is usually weak hip abductors and glutes allowing the knee to collapse inward. Treatment:\n• Quad Sets and Straight Leg Raises strengthen the quads without bending the knee painfully\n• Glute Bridges strengthen the hip abductors and external rotators\n• Avoid deep squats until pain settles\n• Good footwear with arch support makes a real difference\n\nMost cases resolve well with targeted exercise in 6–8 weeks.",
    quickReplies: ['Quad set exercise', 'Straight leg raise', 'Knee exercises', 'Knee and hip plan'],
    exerciseIds: ['quad_sets', 'straight_leg_raise', 'wall_squats'],
    planId: 'knee_14d',
  ),

  ChatIntent(
    id: 'knee_arthritis',
    triggers: [
      ['knee', 'arthritis'],
      ['knee osteoarthritis'],
      ['knee', 'arthritic'],
      ['knee', 'bone on bone'],
      ['knee', 'degenerat'],
    ],
    priority: 3,
    response: "Knee osteoarthritis is the most common joint disease worldwide — but the research is unambiguous: exercise is the most effective treatment available, far more effective than pain medication alone.\n\nKey facts:\n• Cartilage gets its nutrition from movement — it has no blood supply\n• Every 1 kg of weight lost removes 4 kg of force from your knee joint\n• Strong quads dramatically reduce the load through the knee\n• Aqua therapy is excellent if weight-bearing exercise is too painful to start\n\nBest exercises for knee OA:\n• Quad Sets: strengthen without moving the painful joint at all\n• Straight Leg Raises: builds the VMO (inner quad) specifically\n• Wall Squats: functional strength with support and controlled range\n\nThe 14-Day Knee Recovery plan is specifically designed to build strength safely with this condition.",
    quickReplies: ['Quad sets exercise', 'Swimming for knees', 'Weight and knee pain', 'Start knee plan'],
    exerciseIds: ['quad_sets', 'straight_leg_raise', 'wall_squats'],
    planId: 'knee_14d',
  ),

  ChatIntent(
    id: 'knee_swelling',
    triggers: [
      ['knee', 'swollen'],
      ['knee', 'swelling'],
      ['knee', 'inflamed'],
      ['knee', 'puffy'],
      ['knee', 'fluid'],
    ],
    priority: 4,
    response: "A swollen knee means there's excess fluid inside the joint — the body's inflammatory response to irritation, injury, or overuse. Before exercising, it's important to understand the cause.\n\nCommon causes:\n• Overuse (too much activity too soon)\n• Bursitis — inflammation of the fluid sacs around the knee\n• Ligament sprain\n• Meniscus tear\n• Arthritis flare-up\n\nImmediate management — POLICE principle:\n• Protect: avoid what caused it\n• Optimal Load: gentle movement within pain limits (not complete rest)\n• Ice: 15–20 minutes every 2–3 hours for the first 48 hours\n• Compression: a knee sleeve or bandage\n• Elevation: leg raised above heart level when resting\n\nIf swelling came with a popping sound, was caused by trauma, is severe, or won't reduce after 72 hours — see a doctor for imaging.",
    quickReplies: ['Knee exercises', 'When to see a doctor', 'Knee arthritis', 'Knee after injury'],
  ),

  ChatIntent(
    id: 'knee_general',
    triggers: [['knee pain'], ['knee ache'], ['knee hurts'], ['sore knee'], ['my knee']],
    priority: 1,
    response: "Knee pain is incredibly common — the knee is our largest joint and takes enormous forces during daily activities. The location of the pain makes a big difference to the cause.\n\nCould you tell me:\n• Where exactly is the pain? (front, inside, outside, or behind the knee?)\n• Did it come on suddenly after an injury or gradually over time?\n• Is it worse going up or down stairs?\n• Any swelling, clicking, or locking?",
    quickReplies: ['Front knee pain', 'Knee swelling', 'Knee arthritis', 'Knee after injury', 'Knee exercises'],
  ),

  // ── ANKLES & FEET ─────────────────────────────────────────────────

  ChatIntent(
    id: 'ankle_sprain',
    triggers: [
      ['ankle', 'sprain'],
      ['twisted', 'ankle'],
      ['rolled', 'ankle'],
      ['ankle', 'injury'],
      ['ankle', 'rolled'],
    ],
    priority: 4,
    response: "Ankle sprains are the most common sports injury — and even minor ones need proper rehabilitation, or they become a recurring problem.\n\nGrade 1 (mild stretch): 1–2 weeks recovery\nGrade 2 (partial tear): 3–6 weeks\nGrade 3 (complete tear): 6–12 weeks\n\nFirst 48 hours — POLICE:\n• Protect (use crutches if you can't weight-bear comfortably)\n• Optimal Load — gentle movement from day 1 is better than full rest\n• Ice 15–20 minutes every 2–3 hours\n• Compression bandage\n• Elevation above heart level when resting\n\nAfter 48 hours:\n• Ankle Circles gently in all directions\n• Weight-bearing as tolerated\n• Balance exercises as soon as possible — proprioception retraining prevents re-sprains\n\nMost re-sprains happen because people stop rehabilitation too early when it stops hurting.",
    quickReplies: ['Ankle exercises', 'When can I walk?', 'Ankle strengthening', 'When to see a doctor'],
    exerciseIds: ['ankle_circles', 'calf_raises', 'towel_scrunches'],
  ),

  ChatIntent(
    id: 'plantar_fasciitis',
    triggers: [
      ['plantar fasciitis'],
      ['plantar'],
      ['heel pain'],
      ['heel spur'],
      ['foot pain', 'morning'],
      ['first steps', 'pain'],
      ['sore heel'],
    ],
    priority: 4,
    response: "Plantar fasciitis is inflammation of the thick band of connective tissue on the bottom of your foot. The classic presentation is intense heel pain on your very first steps in the morning that eases after a few minutes of walking — then returns after sitting.\n\nWhy it happens:\n• Tight calf muscles put excessive tension on the plantar fascia\n• Sudden increase in high-impact activity\n• Poor footwear (flat shoes, flip flops, barefoot on hard floors)\n• Sudden weight gain\n\nMost effective treatments:\n• Calf stretching — 3 sets of 45 seconds, 3 times daily (this is essential, not optional)\n• Plantar fascia stretch: sit, cross foot over knee, pull toes back and hold\n• Towel Scrunches to strengthen the intrinsic foot muscles\n• Roll a frozen water bottle under the arch for 5 minutes\n• Replace footwear with proper cushioning and arch support\n\nCan take 3–12 months to fully resolve, but significant improvement typically comes within 6–8 weeks of consistent stretching.",
    quickReplies: ['Calf stretching', 'Ankle and foot exercises', 'Footwear advice', 'Morning foot pain tips'],
    exerciseIds: ['calf_raises', 'towel_scrunches', 'ankle_circles'],
  ),

  ChatIntent(
    id: 'ankle_general',
    triggers: [['ankle pain'], ['ankle ache'], ['ankle hurts'], ['sore ankle'], ['ankle stiff']],
    priority: 1,
    response: "Ankle pain can come from the joint, tendons, or ligaments surrounding it. Knowing how it started helps significantly.\n\nCould you tell me:\n• Did it start suddenly after a twist or awkward landing?\n• Is the pain at the front, inside, outside, or behind the ankle?\n• Any swelling, bruising, or warmth?\n• Is it worse in the morning or after activity?\n\nThat will let me give you much more targeted advice!",
    quickReplies: ['Twisted ankle', 'Heel and foot pain', 'Ankle stiffness', 'Ankle exercises'],
  ),

  // ── OTHER AREAS ────────────────────────────────────────────────────

  ChatIntent(
    id: 'wrist_carpal',
    triggers: [
      ['carpal tunnel'],
      ['wrist', 'tingling'],
      ['wrist', 'numbness'],
      ['wrist pain'],
      ['wrist', 'typing'],
      ['hand', 'numbness'],
    ],
    priority: 3,
    response: "Carpal tunnel syndrome is compression of the median nerve as it passes through the carpal tunnel in your wrist. It's extremely common in keyboard users, drivers, and anyone with repetitive hand use.\n\nClassic symptoms:\n• Tingling or numbness in the thumb, index, middle, and half of ring finger\n• Symptoms worse at night or on waking\n• Worse with prolonged wrist flexion (holding a phone, driving)\n• Aching in the forearm\n\nManagement:\n• Neutral wrist positioning at all times — wrist splints at night are very effective\n• Ergonomic keyboard and mouse setup (wrists straight, not bent)\n• Nerve gliding exercises — gently slide the nerve through the tunnel\n• Wrist and forearm stretches\n• Regular breaks from repetitive tasks\n\nSevere or persistent cases — especially with weakness in thumb grip — need medical assessment.",
    quickReplies: ['Wrist exercises', 'Ergonomic setup', 'Desk tips', 'When to see a doctor'],
  ),

  ChatIntent(
    id: 'elbow_tennis',
    triggers: [
      ['tennis elbow'],
      ["golfer's elbow"],
      ['lateral epicondyle'],
      ['elbow', 'pain'],
      ['elbow', 'ache'],
      ['forearm', 'pain'],
    ],
    priority: 3,
    response: "Tennis elbow (lateral epicondylitis) is irritation of the tendons that attach the forearm extensor muscles to the outside of the elbow. Despite the name, most sufferers have never played tennis — it's caused by any repetitive gripping or forearm rotation.\n\nCommon triggers:\n• Mouse use, typing, painting, gardening, screwdriving\n• The tendons are being overloaded relative to their capacity\n\nEvidence-based treatment:\n• Eccentric exercises for the wrist extensors — this is the most effective intervention\n• Reduce the provocative activity while continuing to use the arm normally\n• Forearm strap (counterforce brace) during activities that aggravate it\n• Ice after activity if inflamed\n\nGolfer's elbow is the same concept on the inside of the elbow (medial). Both respond well to the same eccentric loading approach.\n\nPatience is key — tendon healing takes 6–12 weeks even with the right treatment.",
    quickReplies: ['Elbow exercises', 'Ice or heat for elbow', 'Ergonomics and elbow', 'When to see a doctor'],
  ),

  // ── EXERCISES ─────────────────────────────────────────────────────

  ChatIntent(
    id: 'exercise_cat_cow',
    triggers: [['cat cow'], ['cat-cow'], ['cat and cow']],
    priority: 2,
    response: "Cat-Cow is one of the most effective spinal mobilisation exercises. Here's how to do it properly:\n\nStarting position:\n• Hands and knees (quadruped), wrists directly under shoulders, knees under hips\n• Spine in neutral — not yet arched or rounded\n\nCow (inhale):\n• Let your belly drop toward the floor\n• Lift your head and tailbone gently upward\n• Feel the arch move through your entire spine from neck to tailbone\n\nCat (exhale):\n• Round your back toward the ceiling\n• Tuck your chin to your chest and tuck your pelvis under\n• Feel each vertebra separate and space open\n\nTips:\n• Move slowly — this is about mobility, not momentum\n• Breathe with the movement: inhale for Cow, exhale for Cat\n• Do 10–15 slow repetitions\n• Excellent as a morning routine or after prolonged sitting\n\nBenefits: improves spinal mobility, pumps fluid into discs, relieves lower back and thoracic stiffness instantly.",
    quickReplies: ['Bird Dog exercise', 'Pelvic tilt exercise', 'Lower back exercises', 'Morning routine'],
    exerciseIds: ['cat_cow'],
  ),

  ChatIntent(
    id: 'exercise_bird_dog',
    triggers: [['bird dog'], ['bird-dog']],
    priority: 2,
    response: "Bird Dog is one of the best exercises for lumbar spine stability. Done correctly, it trains your deep core (multifidus and transversus abdominis) without compressing or loading the spine.\n\nHow to do it:\n• Start on hands and knees (quadruped position)\n• Keep your spine absolutely neutral — no sagging or arching\n• Draw your navel in very slightly to engage your core\n\nThe movement:\n• Simultaneously extend your right arm forward and your left leg backward\n• Both should reach horizontal — not higher, as that causes your lower back to arch\n• Hold 3–5 seconds, keeping hips completely level (the hardest part)\n• Return slowly — don't let limbs drop\n• Alternate sides\n\nCommon mistakes:\n• Hip rotation — hips must stay square to the floor at all times\n• Arching the lower back to get the leg higher\n• Rushing through the movement for more reps\n\nDo 3 sets of 10 reps each side. Quality over quantity — always.",
    quickReplies: ['Dead Bug exercise', 'Cat-Cow exercise', 'Core exercises', 'Lower back plan'],
    exerciseIds: ['bird_dog'],
  ),

  ChatIntent(
    id: 'exercise_dead_bug',
    triggers: [['dead bug'], ['dead-bug']],
    priority: 2,
    response: "Dead Bug looks unusual but is one of the most effective core stability exercises. It teaches you to keep your spine still while your limbs move — exactly what your core does in real life.\n\nHow to do it:\n• Lie on your back with arms pointing toward the ceiling\n• Bend knees to 90 degrees, shins parallel to the floor (tabletop position)\n• Press your lower back firmly into the floor — this must be maintained throughout\n\nThe movement:\n• Slowly lower your right arm overhead AND your left leg toward the floor simultaneously\n• Go as far as you can while your back stays completely flat — stop before it lifts\n• Return and alternate\n\nKey cues:\n• Your lower back must never leave the floor\n• Exhale as you lower the limbs — this helps maintain back contact\n• Start with a small range and increase as you build control\n\nIf your back lifts off the floor, reduce the range. Start with 3 sets of 6–8 each side.",
    quickReplies: ['Bird Dog exercise', 'Core strengthening', 'Pelvic tilt', 'Lower back pain'],
    exerciseIds: ['dead_bug'],
  ),

  ChatIntent(
    id: 'exercise_glute_bridge',
    triggers: [['glute bridge'], ['hip bridge'], ['bridges exercise'], ['glute bridges']],
    priority: 2,
    response: "Glute Bridges are fundamental in rehabilitation — they strengthen the glutes and hamstrings without loading the spine at all, making them safe for most back, hip, and knee conditions.\n\nHow to do it:\n• Lie on your back, knees bent, feet flat and hip-width apart\n• Arms relaxed by your sides, palms down\n• Feet close enough that fingertips just touch your heels\n\nThe movement:\n• Press through your heels and squeeze your glutes\n• Lift your hips until your body forms a straight line from shoulders to knees\n• Hold 2–3 seconds at the top — really squeeze, don't just hold\n• Lower slowly over 3 counts\n\nProgression:\n• Beginner: 3 sets of 10\n• Intermediate: Single-leg Bridge (one leg extended)\n• Advanced: Bridge with resistance band above knees (prevents knee cave)\n\nWhy they matter: Weak glutes are a root cause of lower back pain, knee pain, and hip problems. These are among the most important exercises in physiotherapy.",
    quickReplies: ['More glute exercises', 'Hip flexor stretch', 'Lower back exercises', 'Knee exercises'],
    exerciseIds: ['glute_bridges'],
  ),

  ChatIntent(
    id: 'exercise_chin_tuck',
    triggers: [['chin tuck'], ['chin tucks'], ['chin retraction'], ['cervical retraction']],
    priority: 2,
    response: "The Chin Tuck is THE most important exercise for neck pain and posture. It strengthens the deep cervical flexors and corrects forward head posture — the root cause of most neck problems.\n\nHow to do it:\n• Sit or stand tall, eyes looking forward — level, not up or down\n• Without nodding (chin stays level), draw your chin straight backward\n• Think: make a double chin\n• You should feel a gentle stretch at the base of your skull\n• Hold 5 seconds, then release\n\nAgainst a wall (better — instant feedback):\n• Stand with your back against a wall, heels 5 cm away\n• Flatten your whole back and draw your chin back to touch the wall\n• This gives you real-time feedback on whether you're doing it correctly\n\nDo 10–15 reps, 3–4 times per day. You can do them hourly at your desk without anyone noticing. Consistent daily practice changes posture measurably within 4–6 weeks.",
    quickReplies: ['Neck pain exercises', 'Tech neck', 'Neck headache', 'Posture correction'],
    exerciseIds: ['chin_tucks'],
  ),

  ChatIntent(
    id: 'exercise_pelvic_tilt',
    triggers: [['pelvic tilt'], ['pelvic tilts']],
    priority: 2,
    response: "The Pelvic Tilt is a safe, gentle starting point for almost any lower back condition. It mobilises the lumbar spine and teaches you to consciously control your pelvic position — a skill that carries into everything you do.\n\nLying down version:\n• Lie on your back, knees bent, feet flat on the floor\n• You'll have a small natural gap between your lower back and the floor\n\nThe movement:\n• Flatten your lower back against the floor by gently tightening your abs\n• Hold 5 seconds, breathe normally\n• Relax and feel the natural curve return\n• Then gently increase the arch (opposite direction)\n• Alternate slowly between these two positions\n\nStanding version (great at desk):\n• Stand against a wall\n• Alternately rock your pelvis forward (creating an arch) and backward (flattening)\n• Find the comfortable middle — that's your neutral position\n\nDo 10–15 repetitions slowly. Often the first exercise prescribed after back pain or surgery — simple but genuinely effective.",
    quickReplies: ['Cat-Cow exercise', 'Core exercises', 'Lower back pain', 'Desk exercises'],
    exerciseIds: ['pelvic_tilts'],
  ),

  ChatIntent(
    id: 'exercise_wall_angel',
    triggers: [['wall angel'], ['wall angels']],
    priority: 2,
    response: "Wall Angels are excellent for resetting shoulder blade mechanics and correcting the rounded-shoulder posture behind most upper back and shoulder pain.\n\nHow to do it:\n• Stand with your back against a wall\n• Feet 5–7 cm from the wall, whole back flat (lower back, mid-back, head)\n• Start with arms at 90 degrees like a goal post — backs of hands touching the wall\n\nThe movement:\n• Slowly slide your arms overhead while keeping everything in contact with the wall\n• Hands, elbows, upper back, and head all stay touching\n• Go as high as you can without losing any contact\n• Slowly slide back down to 90 degrees\n\nThis is much harder than it looks — most people lose contact quickly at first.\n\nCommon mistakes:\n• Upper back arching away from the wall\n• Shoulders shrugging up to the ears\n• Hands losing contact\n\nStart with whatever range you can manage cleanly. 10 slow reps, 2–3 sets. Your range will increase significantly over weeks.",
    quickReplies: ['Shoulder exercises', 'Upper back posture', 'Shoulder impingement', 'Thoracic extension'],
    exerciseIds: ['wall_angels'],
  ),

  ChatIntent(
    id: 'exercise_childs_pose',
    triggers: [["child's pose"], ['childs pose'], ['child pose']],
    priority: 2,
    response: "Child's Pose is a restorative stretch that gently decompresses the lower back and thoracic spine — one of the most immediately relieving positions for back pain.\n\nHow to do it:\n• Start on hands and knees\n• Push your hips back toward your heels\n• Extend your arms forward on the floor, forehead resting down\n• Let your chest sink toward the floor — don't actively push\n\nVariations:\n• Arms forward: stretches the thoracic spine and lats\n• Arms by your sides: more focused on the hips and lower back\n• Knees wide apart: allows more hip flexion and greater lumbar relief\n\nBreathing:\n• Take slow, deep breaths and feel your back expand on each inhale\n• With each exhale, let your body sink a little deeper into the stretch\n• Hold for 30–60 seconds, or longer if it feels good\n\nNote: avoid this position if you have knee problems that make kneeling painful.",
    quickReplies: ['Cat-Cow exercise', 'Lower back exercises', 'Upper back stretch', 'Morning routine'],
    exerciseIds: ['childs_pose'],
  ),

  ChatIntent(
    id: 'exercise_pendulum',
    triggers: [['pendulum'], ['pendulum swing'], ['shoulder pendulum']],
    priority: 2,
    response: "Pendulum Swings are the cornerstone exercise for frozen shoulder and acute shoulder pain — they use gravity to gently distract and mobilise the joint without active muscle effort.\n\nHow to do it:\n• Lean forward with your unaffected hand on a table for support\n• Let the affected arm hang completely relaxed\n• Use your body (gentle swaying of your torso) to create a circular motion in the arm\n• Let gravity and momentum do all the work — the arm should feel heavy and loose\n• Make small circles and gradually increase the size\n• Do clockwise and anticlockwise\n\nKey point:\n• The arm must be completely passive — no active swinging with the shoulder muscles\n• Think of the arm as a pendulum hanging from your shoulder socket\n• If you feel shoulder muscle effort, relax more\n\nDo 2–3 minutes, 2–3 times per day. This is often the only exercise safe to do in the acute freezing phase.",
    quickReplies: ['Frozen shoulder', 'Shoulder exercises', 'Rotator cuff', 'Shoulder pain at night'],
    exerciseIds: ['pendulum_swings'],
  ),

  ChatIntent(
    id: 'exercise_quad_set',
    triggers: [['quad set'], ['quad sets'], ['quadriceps set']],
    priority: 2,
    response: "Quad Sets are the foundational exercise for knee rehabilitation — they strengthen the quadriceps without bending the knee at all, making them safe even in severe pain or post-surgery.\n\nHow to do it:\n• Lie flat on your back with the affected leg straight\n• Place a small rolled towel under the knee for comfort\n• Tighten your quadriceps (front of thigh) by pressing the back of the knee down into the towel\n• You should feel the kneecap lift slightly\n• Hold 5–10 seconds\n• Relax completely, then repeat\n\nWhy they work:\n• The quadriceps (especially the VMO — inner quad) are critical for knee stability\n• Weak quads are a primary driver of knee arthritis pain and patellofemoral syndrome\n• Activating them regularly maintains the muscle and reduces pain without joint stress\n\nDo 3 sets of 15–20 reps. You can do these in bed, on the sofa, or anywhere you lie flat.",
    quickReplies: ['Straight leg raise', 'Knee exercises', 'Knee arthritis', 'Knee and hip plan'],
    exerciseIds: ['quad_sets'],
  ),

  ChatIntent(
    id: 'exercise_thoracic_extension',
    triggers: [['thoracic extension'], ['foam roller', 'back'], ['back extension'], ['thoracic mobilisation']],
    priority: 2,
    response: "Thoracic Extension over a foam roller or rolled towel is one of the most effective exercises for reversing the rounded upper back posture caused by desk work.\n\nHow to do it:\n• Place a foam roller horizontally across your mid-back (not lower back)\n• Sit in front of it, then lie back over it\n• Support your head with your hands, elbows pointing forward\n• Let your upper back gently drape over the roller\n• Hold 30–60 seconds, breathing deeply\n• Move the roller slightly up or down to find different stiff segments\n\nNo foam roller? Use a rolled-up blanket or towel placed on the floor.\n\nWhat to feel:\n• A gentle opening through the mid-thoracic spine\n• A stretch across the chest\n• Some mild discomfort at stiff segments is normal; sharp pain is not\n\nDo this after prolonged sitting or as a daily mobility drill. Over weeks, the thoracic spine genuinely regains extension mobility.",
    quickReplies: ['Cat-Cow exercise', 'Upper back posture', 'Wall angels', 'Posture plan'],
    exerciseIds: ['thoracic_extension'],
  ),

  // ── EXERCISES LISTING ─────────────────────────────────────────────

  ChatIntent(
    id: 'exercises_what',
    triggers: [
      ['what exercises'],
      ['show exercises'],
      ['list exercises'],
      ['suggest exercises'],
      ['exercises do you have'],
      ['what workouts'],
      ['available exercises'],
      ['show me exercises'],
      ['all exercises'],
      ['exercise library'],
    ],
    priority: 2,
    response: "We have 40+ physiotherapy exercises covering every major pain area. Each one includes full step-by-step technique, sets and reps, and physio tips.\n\nExercise categories:\n\n• Lower Back: Bird Dog, Dead Bug, Pelvic Tilt, Cat-Cow, Glute Bridge, Child's Pose\n• Neck & Upper Back: Chin Tucks, Neck Rotation, Wall Angels, Thoracic Extension\n• Shoulders: Pendulum Swings, Cross-Body Stretch, Door Chest Stretch\n• Knees: Terminal Knee Extension, Wall Sit, Step Downs, VMO Taps\n• Hips: Hip Circles, Piriformis Stretch, Clamshells, Hip Flexor Stretch\n• Ankles: Calf Raises, Single Leg Balance, Ankle ABC's\n• Full Body: Superman, Nordic Curl, Squat to Stand\n\nBrowse the full library — tap below or visit the Exercises tab.",
    quickReplies: ['Lower back exercises', 'Knee exercises', 'Neck exercises', 'Show me plans'],
    browseTarget: 'exercises',
  ),

  // ── PLANS ─────────────────────────────────────────────────────────

  ChatIntent(
    id: 'plans_what',
    triggers: [
      ['what plans'],
      ['show plans'],
      ['available plans'],
      ['recommend a plan'],
      ['suggest a plan'],
      ['which plan'],
      ['tell me about plans'],
      ['plans do you have'],
    ],
    priority: 2,
    response: "We have 8 clinically-designed recovery plans covering the most common pain areas. Every plan follows a 3-phase structure:\n\nPhase 1 — Pain Relief: gentle mobility, zero load\nPhase 2 — Recovery: light activation and flexibility\nPhase 3 — Strengthening: stability and functional strength\n\nAvailable plans:\n\nQuick Start (7 days):\n• Lower Back Pain Relief\n• Sciatica Recovery\n• Full Body Mobility\n\nFocused Recovery (14 days):\n• Neck & Desk Worker Recovery\n• Knee Recovery\n• Shoulder Rehabilitation\n\nDeep Transformation (21 days):\n• Hip & Core Strength\n• Posture & Core Reset\n\nAll plans are free, offline, and evidence-based. Browse them below or in the Plans tab.",
    quickReplies: ['Lower back plan', 'Knee plan', 'Shoulder plan', 'How to start a plan'],
    browseTarget: 'plans',
  ),

  ChatIntent(
    id: 'plans_miss_day',
    triggers: [
      ['miss a day'],
      ['missed a day'],
      ['skipped a day'],
      ['forgot a day'],
      ['miss the exercise'],
      ['missed exercise'],
    ],
    priority: 2,
    response: "Missing a day happens — and it doesn't derail your recovery. Here's the research-backed perspective:\n\nOne missed day: No significant impact. Simply continue from where you were.\n\nTwo or more consecutive days: Try to do even 10–15 minutes of gentle movement. It maintains the habit and prevents excessive tightness from resetting your progress.\n\nIn the app: The plan tracks real calendar days. A missed day shows as 'Missed' in your timeline, but your completed days remain completed and your progress is preserved.\n\nPhilosophy: Consistency over perfection. An imperfect plan executed consistently produces better outcomes than a perfect plan abandoned. 80% adherence over a month beats 100% for 2 weeks then stopping every time.",
    quickReplies: ['Rest days explained', 'Plan progress', 'How long are plans?', 'Exercise frequency'],
  ),

  ChatIntent(
    id: 'plans_rest_day',
    triggers: [
      ['rest day'],
      ['is today rest'],
      ['do i rest'],
      ['rest days'],
      ['why rest day'],
    ],
    priority: 2,
    response: "Rest days are programmed into your plan intentionally — they're not optional extras, they're part of the treatment.\n\nWhat happens during rest days:\n• Muscles repair and rebuild from the micro-stress of exercise — this is where strength gains actually occur\n• The nervous system recovers, which improves coordination and motor control\n• Anabolic hormones peak during recovery periods\n• You come back to the next session stronger, not weaker\n\nActive rest — what you can do on rest days:\n• Gentle walking\n• Light stretching (hold each stretch 30 seconds, don't push)\n• Breathing exercises\n• Casual swimming\n\nWhat to avoid:\n• Intense exercise (the temptation to 'make up for' a rest day)\n• Complete inactivity — very gentle movement beats lying still\n\nRest days in the plans fall every 3–4 days. Trust the structure — it's designed this way for a clinical reason.",
    quickReplies: ['Plan structure', 'Miss a day?', 'Exercise frequency', 'Active recovery tips'],
  ),

  ChatIntent(
    id: 'plans_how_long',
    triggers: [
      ['how long', 'plan'],
      ['plan duration'],
      ['how many days', 'plan'],
      ['plan length'],
      ['7 day plan'],
      ['21 day plan'],
      ['14 day plan'],
    ],
    priority: 2,
    response: "Plans come in three lengths based on how much time your condition needs:\n\n7-day (Quick Start):\nPerfect for acute pain or first-timers. Gets you through the most critical early-stage rehabilitation. Most people experience significant pain reduction.\n\n14-day (Focused Recovery):\nAllows complete progression through all three phases with enough volume to build meaningful strength alongside flexibility.\n\n21-day (Deep Transformation):\nFor chronic conditions, post-injury, or those wanting lasting structural change. The strengthening phase has enough duration to produce real muscle and tendon adaptation.\n\nGuidelines:\n• Acute pain → start with 7 days\n• Chronic or recurring pain → 21 days\n• First time doing structured rehab → 7 days to build the habit, then 14–21\n\nYou can only run one plan at a time — this keeps focus and prevents overloading.",
    quickReplies: ['Start a 7-day plan', 'Chronic pain plan', 'Show all plans', 'Can I do two plans?'],
  ),

  ChatIntent(
    id: 'plans_start',
    triggers: [
      ['how to start', 'plan'],
      ['begin a plan'],
      ['enroll', 'plan'],
      ['start plan'],
      ['start a plan'],
    ],
    priority: 2,
    response: "Starting a plan is simple:\n\n1. Go to the Plans tab at the bottom of the screen\n2. Browse the available plans by duration (7, 14, or 21 days)\n3. Tap a plan to see the full day-by-day breakdown\n4. Tap 'Start Plan' at the bottom of the plan detail screen\n\nOnce started:\n• The plan appears on your home screen as an Active Plan card\n• Each day unlocks as a real calendar day passes\n• Mark each day complete after finishing the exercises\n• Rest days are shown clearly in the timeline\n\nOne plan runs at a time — if you want to switch plans, cancel the current one from the plan detail screen first.",
    quickReplies: ['Show all plans', 'Miss a day?', 'Rest days', 'How long are plans?'],
  ),

  // ── GENERAL PHYSIO ADVICE ─────────────────────────────────────────

  ChatIntent(
    id: 'advice_ice_heat',
    triggers: [
      ['ice or heat'],
      ['hot or cold'],
      ['should i use ice'],
      ['should i use heat'],
      ['ice pack'],
      ['heating pad'],
      ['cold or warm'],
      ['ice vs heat'],
    ],
    priority: 2,
    response: "The ice vs heat question is one of the most common in physiotherapy. Here's the clean rule:\n\nICE — first 48–72 hours after an injury or acute flare-up:\n• Reduces inflammation and swelling\n• Numbs acute pain by slowing nerve conduction\n• 15–20 minutes on, at least 45 minutes off\n• Never directly on skin — use a cloth barrier\n\nHEAT — after 72 hours, or for chronic stiffness:\n• Relaxes muscle spasm effectively\n• Increases blood flow and promotes healing\n• Best for stiffness (morning back stiffness → heat first, always)\n• 15–20 minutes\n\nPractical guide:\n• Sudden injury → ice\n• Morning stiffness → heat (warm shower works perfectly)\n• Chronic aching pain without swelling → heat\n• Post-exercise soreness → contrast (alternate ice and heat)\n\nContrast therapy: 1 minute cold, 3 minutes heat, repeat 3–4 cycles — excellent for chronic muscle pain.",
    quickReplies: ['Back pain tips', 'Shoulder pain', 'When to see a doctor', 'Exercise with pain?'],
  ),

  ChatIntent(
    id: 'advice_exercise_frequency',
    triggers: [
      ['how often', 'exercise'],
      ['how many times', 'exercise'],
      ['exercise daily'],
      ['frequency of exercise'],
      ['how many days', 'week'],
    ],
    priority: 2,
    response: "Exercise frequency depends on what you're treating:\n\nAcute pain (first 2 weeks):\n• Daily gentle exercises for 10–15 minutes\n• Nothing aggressive — you're calming inflammation, not building strength yet\n• Mobility and stretching daily is safe and beneficial\n\nRehabilitation (weeks 2–8):\n• Strengthening exercises: every other day — muscles need 48 hours to recover\n• Mobility and stretching: daily is fine and encouraged\n• 3–5 sessions per week is ideal\n\nMaintenance (after recovery):\n• 3 sessions per week maintains all strength gains\n• Daily walking is always beneficial regardless of stage\n\nFor the plans in this app:\n• Follow the plan schedule — rest days are programmed in for a clinical reason\n• Don't skip ahead, even if you feel good — tissues need recovery time\n\nThe plans handle all the scheduling for you.",
    quickReplies: ['Pain while exercising', 'Rest days', 'Morning routine', 'Start a plan'],
  ),

  ChatIntent(
    id: 'advice_pain_while_exercise',
    triggers: [
      ['exercise with pain'],
      ['should i exercise'],
      ['pain during exercise'],
      ['no pain no gain'],
      ['exercise hurts'],
      ['is it safe', 'exercise'],
    ],
    priority: 2,
    response: "'No pain, no gain' is one of the most damaging fitness myths — in physiotherapy, sharp or worsening pain during exercise is a clear signal to stop.\n\nThe traffic light rule:\n\nGREEN — Keep going:\n• Pain 0–3 out of 10\n• Discomfort that stays the same throughout\n• Muscle fatigue or effort sensations\n\nYELLOW — Modify:\n• Pain 4–5 out of 10\n• Discomfort gradually increasing\n• Action: reduce range, reduce reps, or reduce load\n\nRED — Stop immediately:\n• Pain 6+ out of 10\n• Sharp, stabbing, or radiating pain\n• New tingling, numbness, or weakness\n• Pain that keeps climbing during the exercise\n\nPost-exercise: muscle soreness for 24–48 hours (DOMS) is completely normal. Pain lasting more than 48 hours means you did too much — reduce intensity next session.",
    quickReplies: ['Starting gently', 'Exercise frequency', 'When to see a doctor', 'Red flag symptoms'],
  ),

  ChatIntent(
    id: 'advice_posture',
    triggers: [
      ['posture tips'],
      ['good posture'],
      ['correct posture'],
      ['sitting posture'],
      ['standing posture'],
      ['improve posture'],
      ['bad posture'],
    ],
    priority: 2,
    response: "Good posture isn't about sitting rigidly upright — it's about optimal alignment that minimises muscle tension and joint stress.\n\nSitting:\n• Feet flat on the floor, knees at 90 degrees\n• Hips slightly higher than knees\n• Lower back maintaining its natural curve (not flattened or excessively arched)\n• Screen at eye level — top third of monitor\n• Shoulders relaxed, not hunched or pulled back unnaturally\n\nStanding:\n• Weight distributed evenly on both feet\n• Knees soft, not locked out\n• Pelvis in neutral — not tilted forward or tucked under\n• Chin gently in, not poked forward\n\nThe real secret:\nNo posture is perfect indefinitely — the best posture is your NEXT posture. Movement matters more than position. Set a timer every 30 minutes to change position.\n\nWall Angels and Chin Tucks are the two most effective posture correction exercises that exist.",
    quickReplies: ['Wall angel exercise', 'Chin tuck exercise', 'Desk ergonomics', 'Upper back pain'],
    exerciseIds: ['wall_angels', 'chin_tucks', 'thoracic_extension'],
  ),

  ChatIntent(
    id: 'advice_ergonomics',
    triggers: [
      ['desk setup'],
      ['ergonomics'],
      ['workstation'],
      ['computer setup'],
      ['monitor height'],
      ['keyboard height'],
      ['office setup'],
    ],
    priority: 2,
    response: "A proper ergonomic setup can eliminate or dramatically reduce most desk-related pain. Full checklist:\n\nMonitor:\n• Top third of screen at eye level\n• Arm's length away (50–70 cm)\n• No glare — position screen perpendicular to windows\n• Laptop users: get a separate monitor or laptop stand\n\nKeyboard and Mouse:\n• Elbows at 90 degrees, forearms parallel to desk\n• Mouse directly beside keyboard — no reaching\n• Wrists straight, not bent up or down\n\nChair:\n• Seat height: feet flat, knees at 90 degrees\n• Lumbar support at the natural curve of your lower back\n• Sit fully back in the chair\n• Armrests let forearms rest without shoulder shrugging\n\nHabits:\n• Stand or walk every 30–45 minutes (set a timer — seriously)\n• 20-20-20 rule: every 20 minutes, look 20 feet away for 20 seconds\n\nA standing desk is beneficial only if you alternate — standing all day causes its own problems.",
    quickReplies: ['Back pain at desk', 'Neck pain at computer', 'Posture tips', 'Upper back exercises'],
  ),

  ChatIntent(
    id: 'advice_sleep_position',
    triggers: [
      ['sleep position'],
      ['sleeping with pain'],
      ['how to sleep'],
      ['best position', 'sleep'],
      ['pillow for neck'],
      ['pillow for back'],
      ['sleep better', 'pain'],
    ],
    priority: 2,
    response: "Sleep position profoundly affects musculoskeletal pain. Poor positioning means 7–8 hours locked in a bad posture — enough to trigger or worsen most conditions.\n\nFor lower back pain:\n• Best: side-lying with a pillow between your knees\n• OK: back sleeping with a pillow under your knees\n• Avoid: stomach sleeping — forces excessive lumbar extension\n\nFor neck pain:\n• Best: back sleeping with a contour pillow that fills the neck curve\n• OK: side sleeping with a firm pillow that keeps your ear over your shoulder\n• Avoid: stomach sleeping — neck rotated for 8 hours\n\nFor shoulder pain:\n• Avoid lying on the affected shoulder\n• Hug a pillow when side sleeping on the good side\n• Back sleeping: affected arm slightly away from the body on a thin pillow\n\nFor hip pain:\n• Side sleeping: pillow between knees prevents the upper hip dropping\n• Avoid lying on the painful hip — it causes joint compression\n\nPillow rule: one thin pillow for back sleeping, one firmer/thicker pillow for side sleeping.",
    quickReplies: ['Lower back pain tips', 'Neck pain tips', 'Shoulder pain', 'Morning stiffness'],
  ),

  ChatIntent(
    id: 'advice_stretching',
    triggers: [
      ['how to stretch'],
      ['stretching tips'],
      ['static stretch'],
      ['dynamic stretch'],
      ['when to stretch'],
      ['stretching correctly'],
      ['flexibility'],
    ],
    priority: 2,
    response: "Stretching is frequently done incorrectly, reducing its benefit or increasing injury risk. Evidence-based approach:\n\nStatic stretching (hold the position):\n• Best after exercise or as standalone flexibility work\n• Hold 30–45 seconds minimum — less than 30 seconds produces little lasting change\n• Breathe normally and relax into the stretch\n• Should feel a moderate pull, never sharp pain\n• 2–3 repetitions per muscle group\n\nDynamic stretching (controlled movement through range):\n• Best before exercise as a warm-up\n• Leg swings, arm circles, hip rotations, trunk rotations\n• Prepares joints without reducing muscle power output\n\nCommon mistakes:\n• Bouncing (ballistic stretching) — increases injury risk significantly\n• Holding your breath — keeps muscles tense and defeats the purpose\n• Stretching into sharp pain — damages the tissue you're trying to help\n• Stretching cold muscles — always warm up first with brisk walking\n\nFor chronic tightness: daily stretching for 4–6 weeks produces lasting change. Once per week produces almost none.",
    quickReplies: ['Warm-up tips', 'Best stretches for back', 'Flexibility exercises', 'Morning routine'],
  ),

  ChatIntent(
    id: 'advice_core',
    triggers: [
      ['core strengthening'],
      ['strong core'],
      ['core exercises'],
      ['core stability'],
      ['core muscles'],
      ['strengthen core'],
    ],
    priority: 2,
    response: "Your core is not just your six-pack — it's a cylinder of muscles surrounding your spine: the transversus abdominis, multifidus, pelvic floor, and diaphragm. A strong, coordinated core is the foundation of a pain-free back.\n\nCore training priority order for rehabilitation:\n\n1. Diaphragmatic breathing — learn to use your diaphragm, the top of the core cylinder\n2. Pelvic Tilts — learn conscious pelvic control\n3. Dead Bug — core stability while limbs move, spine stays still\n4. Bird Dog — anti-rotation and extension control\n5. Glute Bridge — posterior chain integration\n6. Plank progressions — full core endurance\n\nWhat to avoid early on:\n• Traditional sit-ups (compress the spine under load)\n• Leg raises with a lifting lower back\n• Any exercise that causes lower back arching\n\nCore strength directly reduces lower back pain — the research is unambiguous. Aim for core-specific work 4–5 days per week.",
    quickReplies: ['Dead Bug exercise', 'Bird Dog exercise', 'Lower back plan', 'Plank tips'],
    exerciseIds: ['dead_bug', 'bird_dog', 'pelvic_tilts', 'glute_bridges'],
  ),

  // ── RED FLAGS ─────────────────────────────────────────────────────

  ChatIntent(
    id: 'red_flag_emergency',
    triggers: [
      ["can't move", 'legs'],
      ['loss of bladder'],
      ['loss of bowel'],
      ['cauda equina'],
      ['saddle numbness'],
      ['paralysed'],
      ['paralyzed'],
      ['accident', 'back'],
      ['fell', 'can\'t'],
    ],
    priority: 5,
    response: "STOP — this sounds like it may be serious. Please seek immediate medical attention.\n\nGo to an emergency room or call emergency services immediately if you have:\n• Inability to move or feel your legs\n• Loss of bladder or bowel control\n• Numbness in the saddle area (inner thighs and genitals)\n• Pain following a serious fall or accident\n• Sudden severe headache — the worst of your life\n\nThese symptoms can indicate cauda equina syndrome, spinal cord injury, or other conditions requiring emergency treatment. Do not wait. Do not try to manage these with exercise.",
    quickReplies: ['Call emergency services', 'When to see a doctor', 'Red flag symptoms'],
  ),

  ChatIntent(
    id: 'advice_see_doctor',
    triggers: [
      ['when to see doctor'],
      ['need a doctor'],
      ['should i see a doctor'],
      ['go to hospital'],
      ['see a physio'],
      ['need medical help'],
      ['see a physiotherapist'],
    ],
    priority: 3,
    response: "Knowing when to get professional help is important. Here's a clear guide:\n\nSee a doctor urgently if:\n• Numbness or tingling in both legs simultaneously\n• Loss of bladder or bowel control\n• Pain following significant trauma\n• Unexplained weight loss alongside back pain\n• Severe pain completely unresponsive to any position or rest\n\nSee a physiotherapist if:\n• Pain has lasted more than 6 weeks without clear improvement\n• Pain is progressively worsening despite rest and exercise\n• You've had multiple recurrences of the same injury\n• Daily activities are significantly limited\n• You want a personalised program assessed hands-on\n\nThis app handles common musculoskeletal complaints well — but for complex, progressive, or red-flag cases, a hands-on professional assessment is irreplaceable.",
    quickReplies: ['Red flag symptoms', 'Physiotherapy explained', 'Exercise with pain?', 'Assessment feature'],
  ),

  // ── LIFESTYLE ─────────────────────────────────────────────────────

  ChatIntent(
    id: 'lifestyle_walking',
    triggers: [
      ['walking for pain'],
      ['should i walk'],
      ['walking good for back'],
      ['walking and pain'],
      ['walking exercise'],
      ['is walking good'],
    ],
    priority: 2,
    response: "Walking is genuinely one of the best things you can do for most musculoskeletal conditions — and it costs nothing.\n\nBenefits of walking for pain:\n• Pumps synovial fluid into joints, providing cartilage nutrition\n• Activates the glutes and core, the spine's primary supporters\n• Releases endorphins — the body's natural pain relief system\n• Improves blood flow to healing tissues\n• Gradually rebuilds movement confidence after pain\n\nHow to walk with pain:\n• Start with 10–15 minutes on flat ground\n• Good cushioned footwear (not flip flops or very flat shoes)\n• Arms relaxed, shoulders back and down, gaze forward\n• Don't push through sharp or radiating pain — stop and rest\n• Build up 5–10 minutes per week\n\nFor lower back pain: 20–30 minutes of daily walking is part of evidence-based treatment guidelines. For knee arthritis: 30 minutes five days per week significantly reduces pain over 6 weeks in clinical trials.",
    quickReplies: ['Back pain exercises', 'Knee pain exercises', 'Exercise frequency', 'Swimming for pain'],
  ),

  ChatIntent(
    id: 'lifestyle_swimming',
    triggers: [
      ['swimming for pain'],
      ['swimming good for'],
      ['pool exercise'],
      ['aqua therapy'],
      ['hydrotherapy'],
      ['swimming and back'],
    ],
    priority: 2,
    response: "Swimming and aqua therapy are among the most effective forms of exercise for painful conditions. Water reduces your effective body weight by up to 90% at shoulder depth — dramatically reducing joint load while allowing free movement.\n\nBest suited for:\n• Hip and knee osteoarthritis — movement without compression\n• Conditions where weight-bearing exercise is too painful to start\n• Fibromyalgia\n• Obesity-related joint pain\n• Post-surgical rehabilitation\n\nBest strokes for pain:\n• Backstroke and freestyle: generally spine-friendly\n• Avoid breaststroke with lower back pain — the frog kick forces lumbar extension\n• Avoid breaststroke with knee problems — the kick stresses the medial structures\n\nAqua jogging — running in deep water with a float belt — gives excellent cardiovascular training with zero joint impact.\n\nIf pools aren't accessible, stationary cycling is the closest land-based equivalent for low-impact joint-friendly exercise.",
    quickReplies: ['Knee exercises', 'Hip exercises', 'Low-impact exercise', 'Exercise with arthritis'],
  ),

  ChatIntent(
    id: 'lifestyle_yoga',
    triggers: [
      ['yoga for back'],
      ['yoga for pain'],
      ['yoga and physio'],
      ['yoga exercises'],
      ['pilates'],
    ],
    priority: 2,
    response: "Yoga and physiotherapy have enormous overlap — many yoga poses are essentially physiotherapy exercises with different names. The research supports it strongly.\n\nYoga has strong evidence for:\n• Chronic lower back pain (equivalent outcomes to physiotherapy in multiple RCTs)\n• Flexibility and mobility improvement\n• Stress reduction — which directly reduces pain perception through the nervous system\n• Posture improvement over time\n\nBest yoga styles for pain:\n• Hatha: slow, alignment-focused — ideal\n• Yin: long-held stretches (3–5 minutes) for deep connective tissue\n• Restorative: fully supported positions, very gentle — excellent during flare-ups\n\nAvoid with back or neck pain:\n• Hot yoga — dehydration and fatigue increase injury risk\n• Fast Vinyasa or Power yoga until pain resolves\n• Deep backbends (Wheel, Camel) with lumbar issues\n• Headstands or shoulder stands with neck problems\n\nPilates is similarly excellent — its emphasis on core stability and controlled movement aligns perfectly with physiotherapy principles.",
    quickReplies: ['Stretching tips', 'Core strengthening', 'Back exercises', 'Recovery plans'],
  ),

  // ── ASSESSMENT ────────────────────────────────────────────────────

  ChatIntent(
    id: 'assessment_start',
    triggers: [
      ['take assessment'],
      ['assess my pain'],
      ['check my pain'],
      ['diagnose my pain'],
      ['analyze my pain'],
      ['pain assessment'],
      ['start assessment'],
      ['assess me'],
    ],
    priority: 2,
    response: "The AI Pain Assessment walks you through a structured 5-step evaluation:\n\n1. Select your pain area on an interactive body map\n2. Choose your pain type (sharp, dull, burning, stiffness, or throbbing)\n3. Rate intensity on a 1–10 scale and indicate how long you've had it\n4. AI analysis (takes about 2.5 seconds)\n5. Results: a clinical diagnosis, confidence percentage, and recommended exercises\n\nStart it by tapping the Daily Assessment card on the home screen.\n\nNote: The assessment uses pattern matching against physiotherapy evidence — it gives you a well-informed starting point. For complex, longstanding, or worsening symptoms, a hands-on professional assessment remains irreplaceable.",
    quickReplies: ['How accurate is it?', 'What happens after assessment?', 'Show me plans', 'Exercises for back'],
  ),

  ChatIntent(
    id: 'assessment_how',
    triggers: [
      ['how does assessment work'],
      ['what is the assessment'],
      ['what does assessment do'],
      ['assessment accurate'],
      ['how accurate'],
    ],
    priority: 2,
    response: "The assessment uses a local rule-based engine (no internet required) built on physiotherapy clinical patterns.\n\nHow it works:\n• Your inputs (area + pain type + intensity + duration + age) are matched against clinical presentations\n• Each combination maps to a diagnosis with a confidence percentage\n• Recommended exercises are matched to the diagnosis based on published physiotherapy protocols\n\nWhat it's good at:\n• Common musculoskeletal presentations (back, neck, shoulder, knee, hip, ankle)\n• Giving you a starting point for understanding your pain\n• Recommending appropriate exercises\n\nWhat it can't do:\n• Replace hands-on physical examination\n• Image or test for structural damage\n• Manage complex or unusual presentations\n\nThink of it as a knowledgeable physio friend giving their first impression — valuable, but not a final diagnosis.",
    quickReplies: ['Start assessment', 'Exercises for my area', 'Show recovery plans', 'Talk to physio?'],
  ),

  // ── IT BAND ───────────────────────────────────────────────────────

  ChatIntent(
    id: 'it_band_syndrome',
    triggers: [
      ['it band'],
      ['iliotibial band'],
      ['outer knee pain', 'running'],
      ['lateral knee pain'],
      ['knee pain', 'running'],
      ['runner\'s knee', 'outside'],
    ],
    priority: 3,
    response: "IT Band Syndrome is one of the most common running injuries — and one of the most misunderstood. The iliotibial band is a thick band of connective tissue running from the hip to just below the outer knee. It doesn't stretch much, so it can't be fixed with stretching alone.\n\nWhat actually causes it:\n• Weak hip abductors (gluteus medius) allow the knee to collapse inward\n• Increased running mileage too quickly\n• Downhill running — the IT band works hardest at the moment of landing\n\nWhat works:\n• Strengthen the glutes and hip abductors — Clamshells and Side-Lying Abduction are essential\n• Reduce your running volume by 50% temporarily — don't stop completely\n• Foam roll the outer thigh (not the knee itself) for 60 seconds each side\n• IT Band Stretch daily\n• Fix the underlying cause — weak glutes, not the band itself\n\nNote: foam rolling the IT band directly over the knee is ineffective. The issue is at the hip, not the band itself.",
    quickReplies: ['IT band stretch', 'Clamshells exercise', 'Glute exercises', 'Foam roller IT band'],
    exerciseIds: ['it_band_stretch', 'clamshells', 'side_lying_abduction', 'foam_roller_it_band'],
  ),

  // ── ACHILLES TENDINOPATHY ─────────────────────────────────────────

  ChatIntent(
    id: 'achilles_tendinopathy',
    triggers: [
      ['achilles'],
      ['back of ankle', 'pain'],
      ['achilles tendon'],
      ['tendinopathy'],
      ['back of heel'],
      ['heel cord'],
    ],
    priority: 4,
    response: "Achilles tendinopathy is one of the most frustrating injuries — the tendon is slow to respond, and rest alone rarely helps because deconditioning makes it worse.\n\nKey facts:\n• The Achilles tendon has poor blood supply — healing is inherently slow (3–6 months)\n• Classic presentation: stiff and painful first thing in the morning, warms up after a few minutes, then hurts again after activity\n• Two types: mid-portion (2–6 cm above the heel) and insertional (where it meets the bone)\n\nThe gold-standard treatment:\n• Eccentric Calf Raises — the most evidence-based exercise for Achilles tendinopathy. Three sets of 15, twice daily. Expect mild soreness — that's acceptable\n• Gastrocnemius and Soleus stretches — both essential\n• Avoid hill running and jumping until well recovered\n• Never stretch into the insertional type (where tendon meets bone) — it aggravates it\n\nProgress is slow but predictable with consistent eccentric loading. Most cases significantly improve in 8–12 weeks.",
    quickReplies: ['Eccentric calf raise', 'Calf stretches', 'Plantar fasciitis difference', 'When to see a doctor'],
    exerciseIds: ['eccentric_calf_raise', 'gastrocnemius_stretch', 'soleus_stretch', 'ankle_circles'],
    planId: 'plantar_fasciitis_14d',
  ),

  // ── SHIN SPLINTS ──────────────────────────────────────────────────

  ChatIntent(
    id: 'shin_splints',
    triggers: [
      ['shin splints'],
      ['shin pain'],
      ['medial tibial stress'],
      ['pain', 'front of leg'],
      ['shin', 'running'],
    ],
    priority: 3,
    response: "Shin splints (medial tibial stress syndrome) is pain along the inner border of the shinbone — caused by the bone and surrounding tissues being overloaded, typically from a sudden increase in running volume.\n\nWhy it happens:\n• Too much, too soon — the classic overuse scenario\n• Hard running surfaces (tarmac, concrete)\n• Worn footwear without adequate cushioning\n• Running with excessive foot pronation (feet rolling inward)\n\nManagement:\n• Reduce your running volume by 50% for 2–3 weeks — don't stop entirely\n• Ice shins for 15 minutes after exercise for the first week\n• Calf strengthening prevents recurrence — Calf Raises and Eccentric Calf Raises\n• Ankle Dorsiflexion Stretch improves mechanics that contribute to shin splints\n• Progress running increases by no more than 10% per week going forward\n\nIf the pain is severe, localised to one spot, or worse at rest: get imaging — this can occasionally be a stress fracture which needs rest.",
    quickReplies: ['Calf exercises', 'Ankle exercises', 'Running tips', 'When to see a doctor'],
    exerciseIds: ['calf_raises', 'eccentric_calf_raise', 'ankle_dorsiflexion_stretch', 'gastrocnemius_stretch'],
  ),

  // ── HAMSTRING STRAIN ──────────────────────────────────────────────

  ChatIntent(
    id: 'hamstring_strain',
    triggers: [
      ['hamstring'],
      ['pulled hamstring'],
      ['back of thigh'],
      ['hamstring strain'],
      ['hamstring tear'],
      ['thigh', 'injury'],
    ],
    priority: 3,
    response: "Hamstring strains are one of the most common sports injuries and have a notoriously high re-injury rate — often because people return too early.\n\nGrade 1 (mild): Tightness, minimal strength loss — 1–3 weeks\nGrade 2 (moderate): Clear weakness and bruising possible — 3–8 weeks\nGrade 3 (severe): Cannot bear weight, significant bruising — 8–16 weeks\n\nFirst 48–72 hours:\n• Protect — avoid sprinting, stretching, or heavy loading\n• Gentle active range of motion only\n• Ice 15 minutes every 2–3 hours\n\nAfter 72 hours:\n• Begin gentle stretching — Supine Hamstring Stretch, keeping it below pain threshold\n• Isometric holds: tighten the hamstring against resistance without moving the joint\n• Progress to: Hamstring Curls → Glute Bridges → Nordic Curls\n\nKey insight: the Nordic Hamstring Curl is the best evidence-based exercise for both rehabilitation AND prevention of re-injury. It should be the centrepiece of your recovery from week 2 onward.",
    quickReplies: ['Hamstring stretch', 'Nordic curl exercise', 'Glute bridge exercise', 'Return to sport timeline'],
    exerciseIds: ['supine_hamstring_stretch', 'seated_hamstring_stretch', 'hamstring_curl', 'nordic_curl'],
    planId: 'hamstring_14d',
  ),

  // ── PIRIFORMIS SYNDROME ───────────────────────────────────────────

  ChatIntent(
    id: 'piriformis_syndrome',
    triggers: [
      ['piriformis'],
      ['deep buttock pain'],
      ['buttock pain', 'sitting'],
      ['pain sitting down'],
      ['wallet neuritis'],
    ],
    priority: 3,
    response: "Piriformis syndrome occurs when the piriformis muscle (deep in the buttock) becomes tight and irritates the sciatic nerve that runs either through or beneath it. It mimics sciatica but originates in the buttock, not the spine.\n\nHow to tell it apart from spinal sciatica:\n• Piriformis: pain centred deep in the buttock, worse when sitting, often worse with internal hip rotation\n• Spinal sciatica: pain typically starts in the lower back and radiates down\n\nKey triggers:\n• Long periods of sitting (especially on a wallet in the back pocket — move it!)\n• Running or cycling without sufficient rest\n• Direct trauma to the buttock\n\nWhat helps:\n• Piriformis Stretch: the figure-four stretch (ankle over opposite knee) is excellent\n• 90/90 Hip Stretch to address the surrounding hip capsule\n• Avoid direct pressure on the buttock when sitting — use a cushion or donut ring\n• Hip strengthening reduces the underlying cause\n\nPersistent or worsening symptoms warrant imaging to rule out spinal involvement.",
    quickReplies: ['Piriformis stretch', 'Hip exercises', 'Sciatica vs piriformis', 'Hip and core plan'],
    exerciseIds: ['piriformis_stretch', 'hip_90_90_stretch', 'hip_flexor_stretch', 'glute_bridges'],
    planId: 'hip_core_21d',
  ),

  // ── FIBROMYALGIA / CHRONIC PAIN ───────────────────────────────────

  ChatIntent(
    id: 'fibromyalgia',
    triggers: [
      ['fibromyalgia'],
      ['fibro'],
      ['widespread pain'],
      ['pain everywhere'],
      ['chronic fatigue', 'pain'],
      ['all over pain'],
    ],
    priority: 3,
    response: "Fibromyalgia is a chronic widespread pain condition — your nervous system becomes sensitised and amplifies pain signals from the whole body. It's real, it's complex, and it deserves a careful approach.\n\nKey principles for fibromyalgia:\n• Exercise IS the most effective treatment, but must be introduced very gradually\n• The 'boom-bust cycle' is the biggest trap: overdoing it on good days → crashing for days\n• Aerobic exercise (walking, swimming, cycling) has the strongest evidence — start with just 5–10 minutes\n• Pacing is everything — do less than you think you can manage and build by 10% per week\n\nBest starting exercises:\n• Diaphragmatic Breathing — reduces nervous system sensitisation directly\n• Gentle Cat-Cow — non-threatening spinal mobility\n• Walking — even 5 minutes daily has measurable benefit\n• Warm water exercise (hydrotherapy) is particularly effective if available\n\nWhat to avoid:\n• High-intensity exercise (causes flares)\n• 'Pushing through' significant pain — this worsens sensitisation\n\nAlways work alongside a healthcare team for fibromyalgia — exercise is a key pillar but not the only one.",
    quickReplies: ['Gentle exercises', 'Breathing exercises', 'Walking for pain', 'When to see a doctor'],
    exerciseIds: ['diaphragmatic_breathing', 'cat_cow', 'pelvic_tilts', 'hip_circles'],
  ),

  // ── OSTEOPOROSIS ──────────────────────────────────────────────────

  ChatIntent(
    id: 'osteoporosis',
    triggers: [
      ['osteoporosis'],
      ['bone density'],
      ['brittle bones'],
      ['fragile bones'],
      ['osteopenia'],
    ],
    priority: 3,
    response: "Osteoporosis means reduced bone density — bones become more fragile and fracture more easily. Exercise is one of the most effective non-pharmacological interventions for maintaining and even building bone density.\n\nBest types of exercise for bone health:\n• Weight-bearing impact activities: walking, dancing, gentle jogging — bones respond to impact load\n• Resistance exercises: Glute Bridges, Step-Ups, Squat to Stand — the muscle pull on bone stimulates density\n• Balance training: Single-Leg Balance, Heel-to-Toe Walk — the most important indirect benefit is fall prevention\n\nWhat to avoid:\n• High-risk fall activities (uneven terrain, icy conditions, exercise on unstable surfaces)\n• Spinal flexion exercises if you have vertebral osteoporosis: sit-ups, toe touches, trunk rotations — increased fracture risk\n• Heavy spinal loading\n\nSafe modifications:\n• Cat-Cow (gentle version) instead of full flexion exercises\n• All strengthening exercises in the plans marked 'gentle' are suitable\n\nAlways inform your physiotherapist or GP of an osteoporosis diagnosis before starting a new exercise program.",
    quickReplies: ['Balance exercises', 'Squat to stand', 'Fall prevention plan', 'When to see a doctor'],
    exerciseIds: ['squat_to_stand', 'single_leg_balance', 'glute_bridges', 'calf_raises'],
    planId: 'balance_fall_14d',
  ),

  // ── SCOLIOSIS ─────────────────────────────────────────────────────

  ChatIntent(
    id: 'scoliosis',
    triggers: [
      ['scoliosis'],
      ['curved spine'],
      ['spine curve'],
      ['spinal curvature'],
      ['sideways spine'],
    ],
    priority: 3,
    response: "Scoliosis is a lateral (sideways) curvature of the spine. The vast majority of cases are idiopathic (unknown cause) and most people with mild to moderate scoliosis live normal, active, pain-free lives with the right management.\n\nKey facts:\n• Curves under 20 degrees: exercise and monitoring\n• Curves 20–40 degrees: bracing may be considered in growing adolescents\n• Curves over 45–50 degrees: surgical consultation\n\nBest exercises for scoliosis:\n• Core strengthening that avoids asymmetrical loading\n• Cat-Cow: improves spinal mobility and body awareness\n• Bird Dog and Dead Bug: build the deep stabilising muscles that support the curved spine\n• Diaphragmatic Breathing: the ribcage is often involved in scoliosis — breath work helps expansion\n• Swimming is widely recommended — the horizontal position offloads the spine\n\nWhat NOT to do:\n• High-impact jumping and twisting sports during growth spurts\n• Avoid one-sided heavy loading without counterbalancing on the other side\n\nScoliosis-specific physiotherapy (Schroth method) has the strongest evidence base and should be done with a trained specialist.",
    quickReplies: ['Core exercises', 'Cat-Cow exercise', 'Bird Dog exercise', 'Swimming for pain'],
    exerciseIds: ['cat_cow', 'bird_dog', 'dead_bug', 'diaphragmatic_breathing'],
  ),

  // ── NEW EXERCISES (ADDITIONAL DESCRIPTIONS) ───────────────────────

  ChatIntent(
    id: 'exercise_plank',
    triggers: [['plank exercise'], ['how to plank'], ['forearm plank'], ['plank form']],
    priority: 2,
    response: "The Forearm Plank is one of the most efficient core exercises — it simultaneously trains the deep abdominals, obliques, back extensors, and glutes.\n\nHow to do it correctly:\n• Forearms flat on the floor, elbows directly under your shoulders\n• Toes on the floor, body forming a straight diagonal from head to heels\n• Engage your core by gently drawing the navel toward the spine\n• Squeeze your glutes — this prevents your hips from sagging\n• Keep your neck neutral — look at the floor, not forward\n\nHow long to hold:\n• Beginner: 3 × 15 seconds\n• Intermediate: 3 × 30–45 seconds\n• Advanced: 3 × 60 seconds\n\nCommon mistakes:\n• Hips sagging toward the floor (core fatigue — reduce duration)\n• Hips piked up too high (cheating — form a straight line)\n• Holding your breath — breathe slowly throughout\n\nNote: if you have wrist problems, the forearm version is joint-friendly. If you have lower back pain, start with 10–15 seconds only and build gradually.",
    quickReplies: ['Side plank exercise', 'Dead Bug exercise', 'Core strengthening', 'Lower back plan'],
    exerciseIds: ['plank'],
  ),

  ChatIntent(
    id: 'exercise_clamshell',
    triggers: [['clamshells'], ['clamshell exercise'], ['how to do clamshells']],
    priority: 2,
    response: "Clamshells are one of the most targeted exercises for the gluteus medius — the hip muscle most responsible for knee alignment, hip stability, and IT band problems.\n\nHow to do it:\n• Lie on your side with hips bent to 45 degrees and knees bent to 90 degrees\n• Stack your feet together. Feet and knees stay together throughout.\n• Keep your pelvis completely still — it must not roll backward\n• Lift the top knee upward like a clamshell opening — as far as you can without moving the pelvis\n• Hold 2 seconds at the top, then lower with control\n\nThe pelvis cue is everything:\n• If you feel your pelvis rolling back when you lift the knee, you've gone too far\n• Place one hand on your hip bone to feel it — it must stay still throughout\n\nProgress:\n• Add a resistance band above the knees for significantly more challenge\n• 15 reps is beginner; with a band, 10–12 reps is excellent\n\nThis exercise has huge carryover to knee pain, hip pain, lower back pain, and IT band syndrome.",
    quickReplies: ['Side-lying abduction', 'Hip exercises', 'IT band syndrome', 'Knee pain'],
    exerciseIds: ['clamshells'],
  ),

  ChatIntent(
    id: 'exercise_superman',
    triggers: [['superman exercise'], ['superman extension'], ['how to do superman']],
    priority: 2,
    response: "The Superman Extension is a classic back extension exercise that strengthens the posterior chain — erector spinae, glutes, and hamstrings.\n\nHow to do it:\n• Lie face-down on a mat. Arms extended overhead, legs straight and together.\n• Simultaneously lift your right arm and left leg off the floor — the opposite limbs move together.\n• Hold 3 seconds at the top. Keep your gaze downward — don't strain the neck back.\n• Lower with control, then switch to left arm and right leg.\n\nThings to focus on:\n• The movement should be slow and controlled — not a ballistic throw\n• Start with small lifts and build the range as strength improves\n• You should feel the back extensors (either side of the spine) and the glutes working\n\nWho should use it:\n• Those with general lower back weakness looking to build back extensor strength\n• Should be avoided during acute back pain flare-ups — start with Bird Dog instead\n• An excellent exercise once basic Bird Dog has become easy",
    quickReplies: ['Bird Dog exercise', 'Lower back exercises', 'Core strengthening', 'Prone press-up'],
    exerciseIds: ['superman'],
  ),

  ChatIntent(
    id: 'exercise_nordic_curl',
    triggers: [['nordic curl'], ['nordic hamstring'], ['hamstring strengthening']],
    priority: 2,
    response: "The Nordic Hamstring Curl is the single most evidence-based exercise for hamstring injury prevention and rehabilitation. Studies show it reduces hamstring injury rates in athletes by over 50%.\n\nHow to do it:\n• Kneel on a padded surface (yoga mat, folded towel) with ankles secured under a sofa or heavy piece of furniture\n• Keep your hips and torso in a straight line with your thighs — do not hinge at the hip\n• Slowly lower your body forward by extending at the knee — the hamstrings control the descent\n• Go as far as you can control (aim: forehead to the floor over weeks)\n• When you can no longer control the descent, catch yourself with your hands\n• Use your hands to push yourself back up — the return is concentric and not the focus\n\nStarting point:\n• Even 3–4 slow, controlled reps per set is excellent for beginners\n• The exercise is demanding — start conservatively and build over months\n\nExpect serious hamstring soreness (DOMS) after first sessions — this is normal and reduces over time.",
    quickReplies: ['Hamstring stretch', 'Hamstring strain recovery', 'Back of thigh exercises', 'Return to sport'],
    exerciseIds: ['nordic_curl'],
  ),

  // ── NEW PLANS (DESCRIPTIONS) ──────────────────────────────────────

  ChatIntent(
    id: 'plan_plantar',
    triggers: [
      ['plantar fasciitis plan'],
      ['heel pain plan'],
      ['foot pain plan'],
      ['plantar plan'],
    ],
    priority: 2,
    response: "The Plantar Fasciitis Recovery plan is a structured 14-day program targeting the two main drivers of plantar fasciitis: tight calves and weak intrinsic foot muscles.\n\nPhase breakdown:\n\nDays 1–5 (Pain Relief): Daily calf stretching (gastrocnemius AND soleus separately — both are critical), ankle mobility, and gentle towel scrunches to awaken the foot muscles.\n\nDays 6–10 (Recovery): Progressive calf strengthening with regular calf raises, proprioception work, and ankle dorsiflexion stretching.\n\nDays 11–14 (Strengthening): Eccentric calf raises — the most evidence-based treatment for this condition. Single-leg balance to restore full foot function.\n\nKey principles:\n• Stretch your calves 3 times daily — not just during the session\n• Roll a frozen water bottle under the arch for 5 minutes morning and evening\n• Replace worn-out footwear immediately — flat shoes or flip flops make this much worse\n• Expect gradual improvement over 6–8 weeks even with perfect adherence",
    quickReplies: ['Start plantar fasciitis plan', 'Calf stretching', 'Eccentric calf raise', 'Heel pain advice'],
    planId: 'plantar_fasciitis_14d',
  ),

  ChatIntent(
    id: 'plan_ankle_recovery',
    triggers: [
      ['ankle recovery plan'],
      ['ankle sprain plan'],
      ['ankle rehab plan'],
      ['twisted ankle plan'],
    ],
    priority: 2,
    response: "The Ankle Sprain Recovery plan is a 14-day structured rehabilitation program that follows the complete recovery pathway — from initial mobility through to proprioception training.\n\nMost people skip proprioception (balance training) because the ankle stops hurting — this is the main reason re-sprains happen.\n\nPhase breakdown:\n\nDays 1–4 (Pain Relief): Gentle ankle circles, alphabet circles, and early calf stretching to restore circulation and prevent stiffness.\n\nDays 5–10 (Recovery): Progressive calf strengthening, range-of-motion work, and introduction of single-leg balance to begin retraining the ankle's position sensors.\n\nDays 11–14 (Strengthening): Star Excursion Balance and eccentric calf raises to restore full proprioception and strength — preventing re-injury.\n\nDo NOT return to running or sport until you can perform single-leg balance for 30 seconds with eyes closed without wobbling.",
    quickReplies: ['Start ankle plan', 'Ankle exercises', 'Single-leg balance', 'Sprained ankle advice'],
    planId: 'ankle_recovery_14d',
  ),

  ChatIntent(
    id: 'plan_frozen_shoulder',
    triggers: [
      ['frozen shoulder plan'],
      ['shoulder rehab plan'],
      ['shoulder recovery plan'],
      ['adhesive capsulitis plan'],
    ],
    priority: 2,
    response: "The Frozen Shoulder Rehabilitation plan is a carefully paced 21-day program that respects the natural phases of adhesive capsulitis.\n\nPhase breakdown:\n\nDays 1–7 (Pain Relief): Pendulum swings are the priority — passive, gravity-assisted movement that stimulates the capsule without forcing range. Gentle stretches are introduced alongside.\n\nDays 8–14 (Recovery): Active range-of-motion exercises are added progressively. Wall Angels and external rotation stretches begin restoring the lost movement patterns.\n\nDays 15–21 (Strengthening): Scapular stabilisation work using Band Pull-Aparts, Prone Y Raises, and Seated Rows. These restore the muscle control needed for the shoulder to move properly.\n\nCritical rules for frozen shoulder:\n• Never force range of motion — the capsule responds to gentle, consistent stretch, not force\n• Heat before exercises, ice after if irritated\n• Consistency beats intensity — daily gentle work outperforms occasional intense sessions",
    quickReplies: ['Start frozen shoulder plan', 'Pendulum swing exercise', 'Frozen shoulder advice', 'Rotator cuff'],
    planId: 'frozen_shoulder_21d',
  ),

  ChatIntent(
    id: 'plan_balance',
    triggers: [
      ['balance plan'],
      ['fall prevention plan'],
      ['balance training plan'],
      ['elderly exercise plan'],
      ['older adults plan'],
    ],
    priority: 2,
    response: "The Balance & Fall Prevention plan is a 14-day program that systematically trains all three balance systems — vestibular (inner ear), visual (eyes), and proprioceptive (body position sense).\n\nIt's ideal for:\n• Adults 50+ wanting to reduce fall risk\n• Anyone recovering from an ankle, knee, or hip injury\n• People who feel unsteady or have had a fall\n\nPhase breakdown:\n\nDays 1–4 (Foundation): Chair-supported single-leg balance, tandem stance, and Squat to Stand. All done with support available — building confidence.\n\nDays 5–10 (Dynamic Challenge): Removes support progressively. Star Excursion Balance, Heel-to-Toe Walk, and Lateral Band Walk introduce dynamic challenges.\n\nDays 11–14 (Functional): Step-Ups, unsupported Star Excursion, and challenging combinations that mirror real-life demands.\n\nFall risk drops significantly with just 3–4 weeks of consistent balance training in clinical studies.",
    quickReplies: ['Start balance plan', 'Single-leg balance', 'Fall prevention tips', 'Older adults exercise'],
    planId: 'balance_fall_14d',
  ),

  ChatIntent(
    id: 'plan_wrist_elbow',
    triggers: [
      ['wrist plan'],
      ['elbow plan'],
      ['tennis elbow plan'],
      ['wrist recovery plan'],
      ['forearm plan'],
    ],
    priority: 2,
    response: "The Wrist & Elbow Recovery plan is a 14-day program that addresses tennis elbow, golfer's elbow, carpal tunnel syndrome, and general wrist/forearm pain.\n\nPhase breakdown:\n\nDays 1–4 (Pain Relief): Gentle wrist circles, flexor and extensor stretches, and finger mobility work to restore circulation and reduce stiffness without aggravating inflamed tendons.\n\nDays 5–10 (Recovery): Eccentric wrist curls are introduced — the single most evidence-based treatment for tennis and golfer's elbow. Forearm pronation/supination and grip strengthening are added.\n\nDays 11–14 (Strengthening): Full progressive eccentric loading with all supplementary exercises to restore complete wrist and forearm function.\n\nNote: during this plan, reduce repetitive activities that aggravate the tendon (typing, mouse use, repetitive gripping). A counterforce brace worn just below the elbow during activity can significantly reduce pain while doing the plan.",
    quickReplies: ['Start wrist plan', 'Tennis elbow advice', 'Eccentric wrist curl', 'Carpal tunnel tips'],
    planId: 'wrist_elbow_14d',
  ),

  // ── ADDITIONAL GENERAL ADVICE ─────────────────────────────────────

  ChatIntent(
    id: 'advice_warmup',
    triggers: [
      ['warm up'],
      ['warm-up'],
      ['how to warm up'],
      ['before exercise'],
      ['pre-exercise'],
    ],
    priority: 2,
    response: "A proper warm-up is not a luxury — it's injury prevention. Cold muscles are less elastic, less coordinated, and more prone to strain.\n\nEvidence-based warm-up:\n\n1. Raise your heart rate (3–5 min):\n• Brisk walking, marching on the spot, or slow cycling\n• You should be slightly breathless but able to hold a conversation\n\n2. Dynamic mobility (5 min):\n• Leg swings (front/back and side to side)\n• Hip circles\n• Shoulder rolls and arm circles\n• Standing cat-cow (gentle trunk rotations)\n\n3. Activation exercises (2–3 min):\n• Glute bridges: 10 reps — wakes up the posterior chain\n• Clamshells: 10 reps — activates the gluteus medius\n• Mini squats: 10 reps — prepares the knees and hips\n\nWhat NOT to do before exercise:\n• Static stretching (holding positions 30+ seconds) reduces muscle power output by up to 8%\n• Going straight into full-intensity exercise from rest\n\nFor physio exercise sessions specifically, a 5-minute brisk walk followed by the dynamic mobility routine is ideal.",
    quickReplies: ['Stretching tips', 'Exercise frequency', 'Core exercises', 'Lower back warm-up'],
    exerciseIds: ['hip_circles', 'glute_bridges', 'clamshells', 'mini_squat'],
  ),

  ChatIntent(
    id: 'advice_doms',
    triggers: [
      ['muscle soreness'],
      ['doms'],
      ['sore after exercise'],
      ['delayed onset'],
      ['sore muscles'],
      ['pain after workout'],
    ],
    priority: 2,
    response: "Delayed Onset Muscle Soreness (DOMS) is the normal muscular ache that peaks 24–48 hours after unfamiliar or intense exercise. It's caused by microscopic muscle fibre tears — the mechanism of muscle adaptation and growth.\n\nKey facts:\n• DOMS is normal and a sign of adaptation — not damage\n• It appears 12–24 hours after exercise and peaks at 24–48 hours\n• It always resolves on its own within 72 hours\n• It decreases significantly with each subsequent similar session\n\nWhat genuinely helps:\n• Gentle movement — light walking or gentle stretching speeds recovery more than complete rest\n• Warm bath or shower — reduces perceived soreness\n• Good sleep — most muscle repair happens during sleep\n• Adequate protein intake (0.8–1.2 g/kg body weight daily)\n\nWhat doesn't help:\n• Ice baths post-exercise (blunts the adaptation response if overdone)\n• Anti-inflammatories (NSAIDs) also blunt adaptation — avoid unless pain is severe\n\nIf soreness is sharp, joint-based (not muscular), or persists beyond 72 hours — that's different from DOMS and should be evaluated.",
    quickReplies: ['Ice or heat?', 'Exercise frequency', 'Pain during exercise', 'Rest day advice'],
  ),

  ChatIntent(
    id: 'advice_weight_pain',
    triggers: [
      ['weight', 'joint pain'],
      ['lose weight', 'knee'],
      ['obesity', 'pain'],
      ['overweight', 'pain'],
      ['weight loss', 'pain'],
    ],
    priority: 2,
    response: "Body weight has an enormous impact on joint pain — the relationship is non-linear and the good news applies in both directions.\n\nThe numbers:\n• Every 1 kg of weight lost removes 4 kg of force from your knees during walking\n• Every 1 kg lost removes 6 kg from your knees during stair climbing\n• Hip joint: similar relationship — 3–4 kg force reduction per kg lost\n• The effect on lower back pain is also significant through reduced spinal loading\n\nPractical approach:\n• Even 5% body weight loss produces measurable pain reduction in knee arthritis\n• Anti-inflammatory diet (Mediterranean style) also directly reduces joint inflammation\n• Exercise is a necessary part of weight management — but choose low-impact initially to protect painful joints\n• Walking in water (pool or hydrotherapy) allows exercise with minimal joint load during initial weight loss\n\nCrucially: don't wait until you've lost weight to start exercising. Exercise accelerates weight loss AND reduces pain — they work together.",
    quickReplies: ['Knee exercises', 'Low-impact exercise', 'Hip arthritis advice', 'Swimming for pain'],
  ),

];
