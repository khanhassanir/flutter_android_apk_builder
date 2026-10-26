import 'dart:async';

import 'package:flutter/foundation.dart';
import '../data/hive_boxes/hive_service.dart';
import '../data/models/exercise_plan.dart';
import '../data/models/plan_enrollment.dart';
import '../data/plan_data.dart';

class PlanProvider extends ChangeNotifier {
  Timer? _midnightTimer;

  PlanProvider() {
    _scheduleMidnightRefresh();
  }

  /// Schedules a one-shot timer that fires the instant the device clock rolls
  /// over to the next calendar day.  On firing it notifies listeners (so the
  /// UI recalculates [todayDayNumber] and unlocks the new day immediately)
  /// then re-arms itself for the following midnight.
  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final delay = nextMidnight.difference(now);
    _midnightTimer = Timer(delay, () {
      notifyListeners();
      _scheduleMidnightRefresh(); // arm for the next midnight
    });
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    super.dispose();
  }
  PlanEnrollment? get activeEnrollment {
    try {
      return HiveService.planEnrollmentsBox.values.firstWhere((e) => e.isActive);
    } catch (_) {
      return null;
    }
  }

  ExercisePlan? get activePlan {
    final enrollment = activeEnrollment;
    if (enrollment == null) return null;
    return findPlanById(enrollment.planId);
  }

  int? get todayDayNumber {
    final enrollment = activeEnrollment;
    if (enrollment == null) return null;
    final plan = findPlanById(enrollment.planId);
    if (plan == null) return null;
    final startDate = _dateOnly(enrollment.startDate);
    final diff = _dateOnly(DateTime.now()).difference(startDate).inDays + 1;
    return diff.clamp(1, plan.durationDays);
  }

  bool get isTodayComplete {
    final today = todayDayNumber;
    if (today == null) return false;
    return activeEnrollment?.completedDays.contains(today) ?? false;
  }

  double get progressPercent {
    final enrollment = activeEnrollment;
    if (enrollment == null) return 0;
    final plan = findPlanById(enrollment.planId);
    if (plan == null || plan.durationDays == 0) return 0;

    final completedDays = enrollment.completedDays;
    double base = completedDays.length / plan.durationDays.toDouble();

    // Add fractional credit for today's individually-completed exercises,
    // but only when the day hasn't been fully marked complete yet.
    final today = todayDayNumber;
    if (today != null && !completedDays.contains(today)) {
      final todayDays = plan.days.where((d) => d.dayNumber == today).toList();
      if (todayDays.isNotEmpty) {
        final todayPlanDay = todayDays.first;
        if (!todayPlanDay.isRest && todayPlanDay.exerciseIds.isNotEmpty) {
          final now = DateTime.now();
          final doneCount = todayPlanDay.exerciseIds.where((id) {
            return HiveService.exerciseLogsBox.values.any((log) =>
                log.exerciseId == id &&
                log.completedAt.year == now.year &&
                log.completedAt.month == now.month &&
                log.completedAt.day == now.day);
          }).length;
          base += doneCount /
              (todayPlanDay.exerciseIds.length * plan.durationDays.toDouble());
        }
      }
    }

    return base.clamp(0.0, 1.0);
  }

  bool isEnrolledIn(String planId) {
    final enrollment = activeEnrollment;
    return enrollment != null && enrollment.planId == planId;
  }

  /// True when [dayNumber] is in the future relative to real calendar days elapsed.
  bool isDayLocked(String planId, int dayNumber) {
    if (!isEnrolledIn(planId)) return false;
    final today = todayDayNumber;
    return today == null || dayNumber > today;
  }

  /// True when [dayNumber]'s real date has passed but the day was not completed.
  bool isDayMissed(String planId, int dayNumber) {
    if (!isEnrolledIn(planId)) return false;
    final today = todayDayNumber;
    if (today == null || dayNumber >= today) return false;
    return !(activeEnrollment?.completedDays.contains(dayNumber) ?? false);
  }

  /// Returns true if any plan is currently active (regardless of which).
  bool get hasActivePlan => activeEnrollment != null;

  Future<void> startPlan(String planId) async {
    for (final e in HiveService.planEnrollmentsBox.values) {
      if (e.isActive) {
        e.isActive = false;
        await e.save();
      }
    }
    await HiveService.planEnrollmentsBox.add(
      PlanEnrollment(
        planId: planId,
        startDate: DateTime.now(),
        completedDays: [],
      ),
    );
    notifyListeners();
  }

  Future<void> markTodayComplete() async {
    final enrollment = activeEnrollment;
    final today = todayDayNumber;
    if (enrollment == null || today == null) return;
    if (!enrollment.completedDays.contains(today)) {
      enrollment.completedDays = [...enrollment.completedDays, today];
      await enrollment.save();
      notifyListeners();
    }
  }

  Future<void> abandonPlan() async {
    final enrollment = activeEnrollment;
    if (enrollment == null) return;
    enrollment.isActive = false;
    await enrollment.save();
    notifyListeners();
  }

  void refresh() => notifyListeners();

  static DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}
