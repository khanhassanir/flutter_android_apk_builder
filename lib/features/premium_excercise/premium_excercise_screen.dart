import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:physioai/service/excercise_workoutx_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:physioai/models/excercise.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  List<WorkoutX_Exercise> _exercises = [];
  List<WorkoutX_Exercise> _filteredExercises = [];
  bool _isLoading = true;
  String? _error;

  String _selectedBodyPart = 'All';
  String _selectedDifficulty = 'All';
  String _searchQuery = '';

  List<String> _bodyParts = ['All'];
  final List<String> _difficulties = ['All', 'beginner', 'intermediate', 'expert'];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final exercises = await _exerciseService.getAllExercises();
      setState(() {
        _exercises = exercises;
        _filteredExercises = exercises;
        _isLoading = false;
        final uniqueParts = exercises.map((e) => e.bodyPart).toSet().toList()..sort();
        _bodyParts = ['All', ...uniqueParts];
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        if (_selectedBodyPart != 'All' && exercise.bodyPart != _selectedBodyPart) return false;
        if (_selectedDifficulty != 'All' && exercise.difficulty != _selectedDifficulty) return false;
        if (_searchQuery.isNotEmpty &&
            !exercise.name.toLowerCase().contains(_searchQuery.toLowerCase())) return false;
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Exercise Library',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: _buildFilterBar(),
        ),
      ),
      body: _isLoading
          ? _buildLoadingShimmer()
          : _error != null
              ? _buildErrorWidget()
              : _buildExerciseGrid(),
    );
  }

  Widget _buildFilterBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterChip('Body Part', _selectedBodyPart, _bodyParts),
              const SizedBox(width: 12),
              _buildFilterChip('Difficulty', _selectedDifficulty, _difficulties),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String selectedValue, List<String> options) {
    return GestureDetector(
      onTap: () => _showFilterDialog(label, options, selectedValue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Row(
          children: [
            Text('$label: $selectedValue', style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(String title, List<String> options, String currentValue) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select $title',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((option) {
                return ListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      color: currentValue == option ? Colors.green : Colors.white,
                      fontWeight: currentValue == option ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (title == 'Body Part') {
                        _selectedBodyPart = option;
                      } else {
                        _selectedDifficulty = option;
                      }
                      _applyFilters();
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExerciseGrid() {
    if (_filteredExercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text('No exercises found', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
          ],
        ),
      );
    }

    return MasonryGridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _filteredExercises.length,
      itemBuilder: (context, index) => _ExerciseCard(exercise: _filteredExercises[index]),
    );
  }

  Widget _buildLoadingShimmer() {
    return MasonryGridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[900]!,
          highlightColor: Colors.grey[800]!,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 200 + (index % 3 * 50).toDouble(),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          const Text('Error loading exercises', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Text(_error!, style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() {
              _isLoading = true;
              _error = null;
              _loadExercises();
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final WorkoutX_Exercise exercise;

  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: exercise)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: exercise.gifUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: exercise.gifUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 150,
                        color: Colors.grey[800],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 150,
                        color: Colors.grey[800],
                        child: const Icon(Icons.error_outline, color: Colors.red, size: 50),
                      ),
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[800],
                      child: const Icon(Icons.fitness_center, size: 50, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.fitness_center, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          exercise.equipment,
                          style: TextStyle(color: Colors.grey[500], fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.accessibility_new, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          exercise.target,
                          style: TextStyle(color: Colors.grey[500], fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      exercise.difficulty.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseDetailScreen extends StatelessWidget {
  final WorkoutX_Exercise exercise;

  const ExerciseDetailScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(exercise.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: exercise.gifUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: exercise.gifUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      ),
                    )
                  : Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.fitness_center, size: 100, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          exercise.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          exercise.difficulty.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildInfoChip(Icons.fitness_center, exercise.equipment),
                      _buildInfoChip(Icons.accessibility_new, exercise.target),
                      if (exercise.force != null && exercise.force!.isNotEmpty)
                        _buildInfoChip(Icons.swap_vert, exercise.force!),
                      if (exercise.mechanic != null && exercise.mechanic!.isNotEmpty)
                        _buildInfoChip(Icons.build, exercise.mechanic!),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (exercise.primaryMuscles != null && exercise.primaryMuscles!.isNotEmpty) ...[
                    const Text(
                      'Primary Muscles',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: exercise.primaryMuscles!
                          .map((m) => Chip(
                                label: Text(m),
                                backgroundColor: Colors.grey[800],
                                labelStyle: const TextStyle(color: Colors.white),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (exercise.secondaryMuscles != null && exercise.secondaryMuscles!.isNotEmpty) ...[
                    const Text(
                      'Secondary Muscles',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: exercise.secondaryMuscles!
                          .map((m) => Chip(
                                label: Text(m),
                                backgroundColor: Colors.grey[800],
                                labelStyle: const TextStyle(color: Colors.white),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'Instructions',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...exercise.instructions.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(color: Colors.white, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.green),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
