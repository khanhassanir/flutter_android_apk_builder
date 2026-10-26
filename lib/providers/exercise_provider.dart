import 'package:flutter/foundation.dart';
import '../data/exercise_data.dart';
import '../data/hive_boxes/hive_service.dart';
import '../data/models/exercise.dart';
import '../data/models/exercise_log.dart';

class ExerciseProvider extends ChangeNotifier {
  String _searchQuery = '';
  String? _filterArea;

  String get searchQuery => _searchQuery;
  String? get filterArea => _filterArea;

  List<Exercise> get allExercises => exerciseData;

  List<Exercise> get filteredExercises {
    var list = exerciseData;
    if (_filterArea != null && _filterArea!.isNotEmpty) {
      list = list.where((e) => e.bodyAreas.contains(_filterArea)).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((e) =>
              e.name.toLowerCase().contains(q) ||
              e.targetArea.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterArea(String? area) {
    _filterArea = area;
    notifyListeners();
  }

  Future<void> markDone(String exerciseId, int sets) async {
    final log = ExerciseLog(
      exerciseId: exerciseId,
      completedAt: DateTime.now(),
      setsDone: sets,
    );
    await HiveService.exerciseLogsBox.add(log);
    notifyListeners();
  }

  Exercise? get inProgressExercise {
    final id = HiveService.inProgressExerciseId;
    if (id == null || id.isEmpty) return null;
    try {
      return exerciseData.firstWhere((e) => e.id == id);
    } catch (_) {
      // Library exercise — reconstruct from stored metadata
      final name = HiveService.inProgressExerciseName;
      if (name == null || name.isEmpty) return null;
      return Exercise(
        id: id,
        name: name,
        targetArea: HiveService.inProgressExerciseTargetArea,
        difficulty: HiveService.inProgressExerciseDifficulty,
        durationSeconds: 60,
        repsOrHold: '10 reps',
        sets: 3,
        instructions: HiveService.inProgressExerciseInstructions,
        lottieAsset: '',
        bodyAreas: [HiveService.inProgressExerciseBodyArea],
      );
    }
  }

  String get inProgressImageUrl => HiveService.inProgressExerciseImageUrl;

  List<int> get inProgressCheckedSteps => HiveService.inProgressCheckedSteps;

  void saveInProgressSteps(Set<int> steps) {
    HiveService.inProgressCheckedSteps = steps.toList();
  }

  void setInProgress(String? id) {
    if (id != HiveService.inProgressExerciseId) {
      HiveService.inProgressCheckedSteps = [];
    }
    if (id == null) {
      HiveService.inProgressExerciseName = null;
      HiveService.inProgressExerciseImageUrl = '';
    }
    HiveService.inProgressExerciseId = id;
    notifyListeners();
  }

  void setInProgressFull(Exercise ex, String imageUrl) {
    if (ex.id != HiveService.inProgressExerciseId) {
      HiveService.inProgressCheckedSteps = [];
    }
    HiveService.inProgressExerciseName = ex.name;
    HiveService.inProgressExerciseImageUrl = imageUrl;
    HiveService.inProgressExerciseInstructions = ex.instructions;
    HiveService.inProgressExerciseBodyArea =
        ex.bodyAreas.isNotEmpty ? ex.bodyAreas.first : '';
    HiveService.inProgressExerciseTargetArea = ex.targetArea;
    HiveService.inProgressExerciseDifficulty = ex.difficulty;
    HiveService.inProgressExerciseId = ex.id;
    notifyListeners();
  }

  bool isDoneToday(String exerciseId) {
    final today = DateTime.now();
    return HiveService.exerciseLogsBox.values.any(
      (log) =>
          log.exerciseId == exerciseId &&
          log.completedAt.year == today.year &&
          log.completedAt.month == today.month &&
          log.completedAt.day == today.day,
    );
  }
}
