import '../data/models/daily_check_in.dart';

class DailyInsight {
  final String message;
  final String momentum; // 'improving' | 'stable' | 'declining'
  final int streakDays;
  final String? planNote;
  final bool suggestPlan;

  const DailyInsight({
    required this.message,
    required this.momentum,
    required this.streakDays,
    this.planNote,
    this.suggestPlan = false,
  });
}

class DailyInsightEngine {
  static DailyInsight generate({
    required int todayPain,
    required String exerciseFeel,
    required List<String> symptoms,
    required List<DailyCheckIn> recentHistory,
    String? planName,
    int? planDay,
    int? planTotalDays,
    String? sleepQuality,
    String? energyLevel,
    String? stressLevel,
    String? moodToday,
    String? activityLevel,
  }) {
    final momentum = _momentum(todayPain, recentHistory);
    final message = _buildMessage(
      todayPain: todayPain,
      exerciseFeel: exerciseFeel,
      symptoms: symptoms,
      momentum: momentum,
      history: recentHistory,
      hasPlan: planName != null,
      sleepQuality: sleepQuality,
      energyLevel: energyLevel,
      stressLevel: stressLevel,
      moodToday: moodToday,
      activityLevel: activityLevel,
    );
    final streak = _calculateStreak(recentHistory);
    final planNote = _planNote(planName, planDay, planTotalDays);
    final suggestPlan = planName == null &&
        (momentum == 'declining' || todayPain >= 7);

    return DailyInsight(
      message: message,
      momentum: momentum,
      streakDays: streak,
      planNote: planNote,
      suggestPlan: suggestPlan,
    );
  }

  // ── Momentum ──────────────────────────────────────────────────

  static String _momentum(int todayPain, List<DailyCheckIn> history) {
    if (history.isEmpty) return 'stable';
    final recent = history.take(3).map((c) => c.painLevel);
    final avg = recent.reduce((a, b) => a + b) / recent.length;
    final diff = todayPain - avg;
    if (diff <= -1.5) return 'improving';
    if (diff >= 1.5) return 'declining';
    return 'stable';
  }

  // ── Message builder ───────────────────────────────────────────

  static String _buildMessage({
    required int todayPain,
    required String exerciseFeel,
    required List<String> symptoms,
    required String momentum,
    required List<DailyCheckIn> history,
    required bool hasPlan,
    String? sleepQuality,
    String? energyLevel,
    String? stressLevel,
    String? moodToday,
    String? activityLevel,
  }) {
    String message = _trendMessage(todayPain, momentum, history);

    message += _exerciseModifier(exerciseFeel, momentum);

    if (sleepQuality != null && sleepQuality.isNotEmpty) {
      message += _sleepModifier(sleepQuality, momentum);
    }
    if (energyLevel != null && energyLevel.isNotEmpty) {
      message += _energyModifier(energyLevel, exerciseFeel);
    }
    if (stressLevel != null && stressLevel.isNotEmpty) {
      message += _stressModifier(stressLevel, momentum);
    }
    if (moodToday != null && moodToday.isNotEmpty) {
      message += _moodModifier(moodToday, todayPain, momentum);
    }
    if (activityLevel != null && activityLevel.isNotEmpty) {
      message += _activityModifier(activityLevel, exerciseFeel, momentum);
    }

    if (symptoms.contains('swelling')) {
      message +=
          ' Note: new or increasing swelling — apply ice for 15 minutes and avoid loading that area today.';
    } else if (symptoms.contains('tingling')) {
      message +=
          ' Tingling can indicate nerve involvement. If it persists beyond a few days, speak with a physiotherapist.';
    }

    if (!hasPlan && (momentum == 'declining' || todayPain >= 7)) {
      message +=
          ' A structured recovery plan would guide your daily exercises and help you recover faster — browse plans below.';
    }

    return message;
  }

  static String _trendMessage(
      int todayPain, String momentum, List<DailyCheckIn> history) {
    if (history.isEmpty) {
      return 'Welcome to your first check-in! Logging your pain each day helps us spot recovery patterns early and tailor guidance to your progress.';
    }

    final recent = history.take(3).map((c) => c.painLevel);
    final avg = recent.reduce((a, b) => a + b) / recent.length;
    final diff = todayPain - avg;

    if (diff <= -2.5) {
      return 'Significant improvement — your pain has dropped noticeably. Your consistency is clearly paying off. Keep this momentum going.';
    } else if (diff <= -1.5) {
      return 'Good progress — pain is trending down compared to recent days. Recovery is rarely linear, but you\'re heading in the right direction.';
    } else if (diff.abs() < 1.5) {
      return 'Pain holding steady today. Stability is positive — it means things aren\'t worsening. Consistency now is what builds lasting improvement.';
    } else if (diff < 2.5) {
      return 'Slight increase today — this is normal during recovery and doesn\'t mean you\'re going backwards. Prioritise rest and hydration, and consider a lighter session tomorrow.';
    } else {
      return 'Notable pain increase today. A rest day with gentle mobility-only movement may help more than pushing through. Listen to your body and don\'t skip tomorrow.';
    }
  }

  static String _exerciseModifier(String feel, String momentum) {
    if (feel == 'skipped' && momentum == 'declining') {
      return ' Missing sessions can slow recovery — even 10 minutes of gentle movement is better than nothing.';
    }
    if (feel == 'skipped' && momentum == 'improving') {
      return ' You\'re improving even without today\'s session, but continuing the exercises will accelerate healing.';
    }
    if (feel == 'hard' && momentum == 'declining') {
      return ' The exercises may be too intense right now. Try the easier variants tomorrow and build back up gradually.';
    }
    if (feel == 'easy' && momentum == 'improving') {
      return ' You\'re handling the exercises well — you might be ready to progress to harder variations soon.';
    }
    return '';
  }

  static String _sleepModifier(String sleep, String momentum) {
    if (sleep == 'poorly' && momentum == 'declining') {
      return ' Poor sleep significantly slows tissue recovery — try to get 7–9 hours tonight and keep a consistent sleep time.';
    }
    if (sleep == 'poorly') {
      return ' Sleep quality affects recovery more than most people realise. Aim for 7–9 hours of consistent sleep.';
    }
    if (sleep == 'well' && momentum == 'improving') {
      return ' Great sleep is fuelling your recovery — keep that routine going.';
    }
    return '';
  }

  static String _energyModifier(String energy, String feel) {
    if (energy == 'low' && feel != 'skipped') {
      return ' With low energy today, consider going at 70% intensity — consistent movement matters more than pushing hard.';
    }
    if (energy == 'low' && feel == 'skipped') {
      return ' Low energy is a valid reason to rest, but try some gentle stretching to keep circulation going.';
    }
    if (energy == 'good') {
      return ' Good energy levels today — make the most of your session.';
    }
    return '';
  }

  static String _stressModifier(String stress, String momentum) {
    if (stress == 'stressed' && momentum == 'declining') {
      return ' High stress elevates cortisol, which actively delays tissue repair. Even 5 minutes of slow breathing today can help your body shift into recovery mode.';
    }
    if (stress == 'stressed') {
      return ' Stress can amplify pain signals and slow healing. Try a short walk, breathing exercise, or anything that helps you decompress today.';
    }
    if (stress == 'calm' && momentum == 'improving') {
      return ' Staying calm and relaxed is actively helping your recovery — the nervous system plays a bigger role in healing than most people realise.';
    }
    return '';
  }

  static String _moodModifier(String mood, int pain, String momentum) {
    if (mood == 'low' && pain >= 6) {
      return ' Low mood and higher pain often feed each other. Even small wins today — a short walk, a good meal — can break that cycle.';
    }
    if (mood == 'low' && momentum == 'declining') {
      return ' When mood is low it\'s easy to feel like progress has stalled. Your data tells a different story — recovery has ups and downs by design.';
    }
    if (mood == 'good' && momentum == 'improving') {
      return ' Your positive mindset is a real asset — research consistently shows that mood and recovery speed are linked.';
    }
    return '';
  }

  static String _activityModifier(
      String activity, String feel, String momentum) {
    if (activity == 'resting' && momentum == 'improving') {
      return ' Rest is productive recovery — your body is repairing while you\'re still.';
    }
    if (activity == 'resting' && feel == 'skipped') {
      return ' A full rest day is fine occasionally, but try to include at least 10 minutes of gentle movement tomorrow.';
    }
    if (activity == 'active' && momentum == 'improving') {
      return ' Staying active while improving is the ideal recovery pattern — keep building on this.';
    }
    if (activity == 'active' && momentum == 'declining') {
      return ' High activity combined with increasing pain is worth monitoring. Consider scaling back tomorrow to let tissues recover.';
    }
    return '';
  }

  // ── Streak ────────────────────────────────────────────────────

  static int _calculateStreak(List<DailyCheckIn> history) {
    int streak = 1;
    final now = DateTime.now();
    for (int i = 1; i <= 30; i++) {
      final expected = DateTime(now.year, now.month, now.day - i);
      final found = history.any((c) =>
          c.date.year == expected.year &&
          c.date.month == expected.month &&
          c.date.day == expected.day);
      if (found) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  // ── Plan note ─────────────────────────────────────────────────

  static String? _planNote(String? name, int? day, int? total) {
    if (name == null || day == null || total == null) return null;
    final remaining = total - day;
    if (remaining <= 0) {
      return 'You\'ve completed your $name plan — outstanding commitment.';
    }
    return 'Day $day of $total on your $name. $remaining day${remaining == 1 ? '' : 's'} to go.';
  }
}
