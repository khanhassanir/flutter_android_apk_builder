/// Represents a single day within an exercise plan.
class PlanDay {
  final int dayNumber;
  final List<String> exerciseIds;
  final int estimatedMinutes;
  final bool isRest;
  final String phaseName;

  const PlanDay({
    required this.dayNumber,
    required this.exerciseIds,
    required this.estimatedMinutes,
    this.isRest = false,
    required this.phaseName,
  });
}

/// A clinical-phase within a plan (e.g. Pain Relief, Recovery, Strengthening).
class PlanPhase {
  final String name;
  final String description;
  final int startDay;
  final int endDay;

  const PlanPhase({
    required this.name,
    required this.description,
    required this.startDay,
    required this.endDay,
  });
}

/// A complete exercise plan with phased structure.
class ExercisePlan {
  final String id;
  final String name;
  final String description;
  final String targetArea;
  final int durationDays;
  final String difficulty; // 'gentle', 'active', 'strengthening'
  final List<PlanPhase> phases;
  final List<PlanDay> days;

  const ExercisePlan({
    required this.id,
    required this.name,
    required this.description,
    required this.targetArea,
    required this.durationDays,
    required this.difficulty,
    required this.phases,
    required this.days,
  });

  int get totalExercises {
    final ids = <String>{};
    for (final d in days) {
      ids.addAll(d.exerciseIds);
    }
    return ids.length;
  }

  int get restDayCount => days.where((d) => d.isRest).length;
  int get activeDayCount => days.where((d) => !d.isRest).length;

  String get difficultyLabel {
    switch (difficulty) {
      case 'gentle':
        return 'Gentle';
      case 'active':
        return 'Active';
      case 'strengthening':
        return 'Strengthening';
      default:
        return difficulty;
    }
  }

  /// Returns the PlanPhase for a given day number.
  PlanPhase phaseForDay(int dayNumber) {
    return phases.firstWhere(
      (p) => dayNumber >= p.startDay && dayNumber <= p.endDay,
      orElse: () => phases.last,
    );
  }
}
