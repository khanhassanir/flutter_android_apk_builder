import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:physioai/models/excercise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseService {
  static const String _freeDBUrl =
      'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json';

  static const String cacheKey = 'cached_exercises_v4';
  static const Duration cacheDuration = Duration(hours: 24);

  Future<List<WorkoutX_Exercise>> getAllExercises() async {
    final cached = await getCachedExercises();
    if (cached != null) {
      print('✅ Loaded ${cached.length} exercises from cache');
      return cached;
    }

    print('🔄 Fetching from free-exercise-db...');
    final exercises = await _fetchFromFreeDB();
    print('✅ Loaded ${exercises.length} exercises');
    await cacheExercises(exercises);
    return exercises;
  }

  Future<List<WorkoutX_Exercise>> _fetchFromFreeDB() async {
    final response = await http.get(Uri.parse(_freeDBUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load exercises (HTTP ${response.statusCode})');
    }
    final List<dynamic> data = json.decode(response.body);
    return data.map((j) => WorkoutX_Exercise.fromFreeDBJson(j)).toList();
  }

  Future<void> cacheExercises(List<WorkoutX_Exercise> exercises) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = exercises.map((e) => jsonEncode({
      'id': e.id,
      'name': e.name,
      'bodyPart': e.bodyPart,
      'target': e.target,
      'equipment': e.equipment,
      'gifUrl': e.gifUrl,
      'caloriesBurn': e.caloriesBurn,
      'difficulty': e.difficulty,
      'instructions': e.instructions,
      'force': e.force,
      'mechanic': e.mechanic,
      'primaryMuscles': e.primaryMuscles,
      'secondaryMuscles': e.secondaryMuscles,
    })).toList();

    await prefs.setStringList(cacheKey, encoded);
    await prefs.setInt('${cacheKey}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<WorkoutX_Exercise>?> getCachedExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('${cacheKey}_timestamp');
    if (timestamp == null) return null;

    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > cacheDuration.inMilliseconds) return null;

    final stored = prefs.getStringList(cacheKey);
    if (stored == null) return null;

    return stored.map((s) {
      final j = jsonDecode(s);
      return WorkoutX_Exercise(
        id: j['id'],
        name: j['name'],
        bodyPart: j['bodyPart'],
        target: j['target'],
        equipment: j['equipment'],
        gifUrl: j['gifUrl'] ?? '',
        caloriesBurn: j['caloriesBurn'],
        difficulty: j['difficulty'],
        instructions: List<String>.from(j['instructions']),
        force: j['force'],
        mechanic: j['mechanic'],
        primaryMuscles: j['primaryMuscles'] != null ? List<String>.from(j['primaryMuscles']) : null,
        secondaryMuscles: j['secondaryMuscles'] != null ? List<String>.from(j['secondaryMuscles']) : null,
      );
    }).toList();
  }
}
