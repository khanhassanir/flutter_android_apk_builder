enum ChatPhase { active, postFlow, ended }

const terminalFollowup = <String, (String, String)>{
  'lower_back': (
    'How long until I see improvement?',
    'Most people notice meaningful improvement in lower back pain within 2–4 weeks of consistent exercise. Acute episodes often resolve within 6 weeks. If you\'re not seeing progress by week 4, a hands-on physiotherapy assessment is worthwhile.',
  ),
  'neck': (
    'Can I use heat or ice for neck pain?',
    'For the first 48–72 hours, use ice (wrapped in cloth, 15 min on/off) to reduce inflammation. After that, switch to heat — a warm compress relaxes tight muscles and improves circulation. Avoid direct heat on a fresh injury.',
  ),
  'shoulder': (
    'Should I rest my shoulder completely?',
    'Complete rest usually makes shoulder problems worse. Stay gently active within a pain-free range to keep the joint healthy and prevent stiffness. Avoid heavy lifting and overhead work, but keep the arm moving lightly throughout the day.',
  ),
  'knee': (
    'Is it safe to walk with knee pain?',
    'Light walking is generally safe and beneficial — it pumps synovial fluid and strengthens supporting muscles. Stop if pain exceeds 4/10 or the knee swells after walking. Flat surfaces are best while recovering.',
  ),
  'hip': (
    'What activities should I avoid?',
    'Avoid deep squats, crossing your legs when sitting, and high-impact activities like running on hard surfaces. Low-impact movement like swimming or cycling is usually well-tolerated and helps maintain range of motion.',
  ),
  'upper_back': (
    'Will improving my posture help?',
    'Yes — posture correction is one of the most effective long-term strategies for upper back pain. Even 5 minutes of postural exercises per hour can significantly reduce muscle fatigue. Ergonomic adjustments like monitor height and chair support are equally important.',
  ),
  'ankle': (
    'When can I return to sport?',
    'A mild ankle sprain typically takes 1–2 weeks of rehab. Moderate sprains take 3–6 weeks. Restore full range of motion and balance before returning — rushing back is the most common cause of re-injury.',
  ),
};

const doctorResponse =
    'See a doctor or physiotherapist if:\n\n'
    '• Pain is severe (7+/10) and not improving with rest\n'
    '• You experience numbness, tingling, or limb weakness\n'
    '• Pain started after a fall, collision, or accident\n'
    '• There is visible swelling, bruising, or joint instability\n'
    '• Pain consistently wakes you from sleep\n'
    '• Symptoms haven\'t improved after 4–6 weeks of home exercise\n\n'
    'Seek emergency care for: loss of bladder or bowel control, chest pain, or a sudden severe headache.';

class ChatMessage {
  final String text;
  final bool isUser;
  final List<String> quickReplies;
  final List<String> exerciseIds;
  final String? planId;
  final String? browseTarget;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.quickReplies = const [],
    this.exerciseIds = const [],
    this.planId,
    this.browseTarget,
  });
}
