import 'package:flutter/material.dart';
import 'package:physioai/models/excercise.dart';
import 'package:physioai/service/excercise_workoutx_service.dart';

class LibraryProvider extends ChangeNotifier {
  final ExerciseService _service = ExerciseService();

  List<WorkoutX_Exercise> _exercises = [];
  bool _isLoading = false;
  String? _error;

  List<WorkoutX_Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get bodyParts {
    final parts = _exercises.map((e) => e.bodyPart).toSet().toList();
    parts.sort();
    return parts;
  }

  List<WorkoutX_Exercise> byBodyPart(String bodyPart) =>
      _exercises.where((e) => e.bodyPart == bodyPart).toList();

  Future<void> load() async {
    if (_exercises.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();
    try {
      _exercises = await _service.getAllExercises();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
