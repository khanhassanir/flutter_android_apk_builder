class WorkoutX_Exercise {
  final String id;
  final String name;
  final String bodyPart;
  final String target;
  final String equipment;
  final String gifUrl;
  final int? caloriesBurn;
  final String difficulty;
  final List<String> instructions;
  final String? force;
  final String? mechanic;
  final List<String>? primaryMuscles;
  final List<String>? secondaryMuscles;

  WorkoutX_Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    required this.gifUrl,
    this.caloriesBurn,
    required this.difficulty,
    required this.instructions,
    this.force,
    this.mechanic,
    this.primaryMuscles,
    this.secondaryMuscles,
  });

  static const String _rawBase =
      'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/';

  factory WorkoutX_Exercise.fromFreeDBJson(Map<String, dynamic> json) {
    final images = json['images'] as List?;
    final imageUrl = (images != null && images.isNotEmpty)
        ? '$_rawBase${images[0]}'
        : '';

    return WorkoutX_Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bodyPart: json['primaryMuscles']?.isNotEmpty == true
          ? json['primaryMuscles'][0]
          : '',
      target: json['primaryMuscles']?.isNotEmpty == true
          ? json['primaryMuscles'][0]
          : '',
      equipment: json['equipment'] ?? '',
      gifUrl: imageUrl,
      caloriesBurn: null,
      difficulty: json['level'] ?? 'beginner',
      instructions: List<String>.from(json['instructions'] ?? []),
      force: json['force'],
      mechanic: json['mechanic'],
      primaryMuscles: json['primaryMuscles'] != null
          ? List<String>.from(json['primaryMuscles'])
          : null,
      secondaryMuscles: json['secondaryMuscles'] != null
          ? List<String>.from(json['secondaryMuscles'])
          : null,
    );
  }
}
