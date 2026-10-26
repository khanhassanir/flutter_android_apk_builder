import 'package:flutter/foundation.dart';
import '../data/hive_boxes/hive_service.dart';
import '../data/models/assessment_result.dart';
import '../data/models/daily_check_in.dart';
import '../data/models/exercise_log.dart';

class ProgressProvider extends ChangeNotifier {
  void refresh() => notifyListeners();

  List<DailyCheckIn> get checkIns {
    return HiveService.checkInsBox.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<AssessmentResult> get assessments {
    return HiveService.assessmentsBox.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<ExerciseLog> get exerciseLogs {
    return HiveService.exerciseLogsBox.values.toList()
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));
  }

  int get totalExercisesCompleted => exerciseLogs.length;

  int get totalPlansDone => HiveService.planEnrollmentsBox.values.length;

  int get totalAiChats => HiveService.chatCount;

  List<int> get weeklyActivityTotals {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = DateTime(now.year, now.month, now.day - (6 - i));
      final ex = exerciseLogs.where((e) =>
        e.completedAt.year == day.year &&
        e.completedAt.month == day.month &&
        e.completedAt.day == day.day).length;
      final ci = checkIns.where((c) =>
        c.date.year == day.year &&
        c.date.month == day.month &&
        c.date.day == day.day).length;
      return ex + ci;
    });
  }

  List<String> get weeklyDayLabels {
    const abbr = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = DateTime(now.year, now.month, now.day - (6 - i));
      return abbr[(day.weekday - 1) % 7];
    });
  }

  int get currentStreak {
    if (checkIns.isEmpty) return 0;
    final today = DateTime.now();
    int streak = 0;
    for (int i = 0; i < 90; i++) {
      final day = DateTime(today.year, today.month, today.day - i);
      final hasCheckIn = checkIns.any((c) =>
          c.date.year == day.year &&
          c.date.month == day.month &&
          c.date.day == day.day);
      if (hasCheckIn) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return streak;
  }

  List<DailyCheckIn> get last7DaysCheckIns {
    final today = DateTime.now();
    final cutoff = today.subtract(const Duration(days: 6));
    return checkIns.where((c) => c.date.isAfter(cutoff)).toList();
  }

  Map<String, int> get areaFrequency {
    final map = <String, int>{};
    for (final a in assessments) {
      map[a.area] = (map[a.area] ?? 0) + 1;
    }
    return map;
  }

  List<String> get aiInsights {
    final insights = <String>[];
    final checkInsLast7 = last7DaysCheckIns;

    if (checkInsLast7.length >= 2) {
      final first = checkInsLast7.first.painLevel;
      final last = checkInsLast7.last.painLevel;
      final diff = first - last;
      if (diff > 0) {
        final pct = ((diff / first) * 100).round();
        insights.add('Your pain level dropped by $pct% this week. Great progress!');
      } else if (diff < 0) {
        insights.add('Pain levels have increased slightly this week. Consider scheduling a new assessment.');
      }
    }

    if (currentStreak >= 3) {
      insights.add('You\'ve been consistent for $currentStreak days in a row. Keep it up!');
    }

    if (totalExercisesCompleted >= 10) {
      insights.add('You\'ve completed $totalExercisesCompleted exercises total. Excellent dedication!');
    }

    final freq = areaFrequency;
    if (freq.isNotEmpty) {
      final topArea = freq.entries.reduce((a, b) => a.value > b.value ? a : b);
      final areaLabel = _areaLabel(topArea.key);
      insights.add('Your $areaLabel has been your most assessed area. Keep focusing on it.');
    }

    final morningCheckIns = checkIns.where((c) => c.date.hour < 12).length;
    final totalCheckIns = checkIns.length;
    if (totalCheckIns > 3 && morningCheckIns / totalCheckIns > 0.6) {
      insights.add('You\'re most consistent with morning check-ins. That\'s a great habit!');
    }

    if (insights.isEmpty) {
      insights.add('Complete daily check-ins to start seeing AI-powered insights about your recovery.');
    }

    return insights;
  }

  Future<void> saveCheckIn(int painLevel) async {
    final today = DateTime.now();
    final existing = HiveService.checkInsBox.values.where((c) =>
        c.date.year == today.year &&
        c.date.month == today.month &&
        c.date.day == today.day);

    if (existing.isNotEmpty) {
      final key = existing.first.key;
      await HiveService.checkInsBox.put(key, DailyCheckIn(date: today, painLevel: painLevel));
    } else {
      await HiveService.checkInsBox.add(DailyCheckIn(date: today, painLevel: painLevel));
    }
    notifyListeners();
  }

  int? get todayCheckIn {
    final today = DateTime.now();
    final match = checkIns.where((c) =>
        c.date.year == today.year &&
        c.date.month == today.month &&
        c.date.day == today.day);
    return match.isEmpty ? null : match.first.painLevel;
  }

  static String _areaLabel(String area) {
    const map = {
      'neck': 'neck',
      'shoulders': 'shoulders',
      'upper_back': 'upper back',
      'lower_back': 'lower back',
      'hips': 'hips',
      'knees': 'knees',
      'ankles': 'ankles',
    };
    return map[area] ?? area;
  }
}
