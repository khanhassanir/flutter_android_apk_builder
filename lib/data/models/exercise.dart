class Exercise {
  final String id;
  final String name;
  final String targetArea;
  final String difficulty;
  final int durationSeconds;
  final String repsOrHold;
  final int sets;
  final List<String> instructions;
  final String lottieAsset;
  final List<String> bodyAreas;

  const Exercise({
    required this.id,
    required this.name,
    required this.targetArea,
    required this.difficulty,
    required this.durationSeconds,
    required this.repsOrHold,
    required this.sets,
    required this.instructions,
    required this.lottieAsset,
    required this.bodyAreas,
  });

  String get difficultyLabel {
    switch (difficulty) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return difficulty;
    }
  }

  String get durationLabel {
    if (durationSeconds < 60) return '${durationSeconds}s';
    return '${(durationSeconds / 60).round()} min';
  }
}
