import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/models/exercise.dart';
import 'package:physioai/extension_function/for_strings.dart';
import 'package:physioai/features/exercises/exercise_detail_screen.dart';
import 'package:physioai/models/excercise.dart';

class LibraryCategoryScreen extends StatefulWidget {
  final String bodyPart;
  final List<WorkoutX_Exercise> exercises;
  final Color color;

  const LibraryCategoryScreen({
    super.key,
    required this.bodyPart,
    required this.exercises,
    required this.color,
  });

  @override
  State<LibraryCategoryScreen> createState() => _LibraryCategoryScreenState();
}

class _LibraryCategoryScreenState extends State<LibraryCategoryScreen> {
  String _difficulty = 'all';

  static const _filters = [
    ('all', 'All'),
    ('beginner', 'Beginner'),
    ('intermediate', 'Intermediate'),
    ('expert', 'Expert'),
  ];

  List<WorkoutX_Exercise> get _filtered {
    if (_difficulty == 'all') return widget.exercises;
    return widget.exercises.where((e) => e.difficulty == _difficulty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backgroundColor,
            AppColors.backgroundColor2,
            AppColors.backgroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _TopBar(label: widget.bodyPart.toTitleCase()),
              const Divider(color: AppColors.divider, height: 1, thickness: 1),
              _FilterRow(
                selected: _difficulty,
                onChanged: (d) => setState(() => _difficulty = d),
                filters: _filters,
              ),
              Expanded(
                child: _filtered.isEmpty
                    ? _EmptyState(color: widget.color)
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 120.h),
                        itemCount: _filtered.length,
                        itemBuilder: (context, i) => _LibraryExerciseItem(
                          exercise: _filtered[i],
                          color: widget.color,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top Bar ──────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String label;
  const _TopBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded,
                  color: AppColors.primaryTextColor, size: 22.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter Row ───────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;
  final List<(String, String)> filters;

  const _FilterRow({
    required this.selected,
    required this.onChanged,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final (key, label) = filters[i];
          final isSelected = selected == key;
          return GestureDetector(
            onTap: () => onChanged(key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryTextColor : Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  color: isSelected
                      ? Colors.white
                      : AppColors.primaryTextColor.withValues(alpha: 0.55),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Exercise Item ─────────────────────────────────────────────────

Exercise _toExercise(WorkoutX_Exercise e) {
  final bodyArea = e.bodyPart.toLowerCase().replaceAll(' ', '_');
  return Exercise(
    id: e.id,
    name: e.name,
    targetArea: e.bodyPart.isEmpty
        ? e.target
        : e.bodyPart[0].toUpperCase() + e.bodyPart.substring(1),
    difficulty: e.difficulty == 'expert' ? 'advanced' : e.difficulty,
    durationSeconds: 60,
    repsOrHold: '10 reps',
    sets: 3,
    instructions: e.instructions,
    lottieAsset: '',
    bodyAreas: [bodyArea],
  );
}

class _LibraryExerciseItem extends StatelessWidget {
  final WorkoutX_Exercise exercise;
  final Color color;

  const _LibraryExerciseItem({required this.exercise, required this.color});

  @override
  Widget build(BuildContext context) {
    // Get card color based on difficulty
    Color getCardColor() {
      switch (exercise.difficulty.toLowerCase()) {
        case 'beginner':
          return AppColors.recentSessionCard; // Your existing blue
        case 'intermediate':
          return AppColors.aiSugesstionCard; // Pastel purple
        case 'expert':
          return AppColors.dailyAssessment/*Color(0xFFEF5350)*/; // Pastel red
        default:
          return color; // fallback to passed color
      }
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(
            exercise: _toExercise(exercise),
            color: getCardColor(),
            imageUrl: exercise.gifUrl,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              getCardColor(),
              getCardColor().withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: getCardColor().withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: getCardColor().withValues(alpha: 0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail with improved styling
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(22)),
              child: Stack(
                children: [
                  exercise.gifUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: exercise.gifUrl,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 80.w,
                      height: 80.h,
                      color: Colors.white.withValues(alpha: 0.2),
                      child: Icon(Icons.fitness_center_rounded,
                          size: 28.sp,
                          color: Colors.white.withValues(alpha: 0.7)),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 80.w,
                      height: 80.h,
                      color: Colors.white.withValues(alpha: 0.2),
                      child: Icon(Icons.fitness_center_rounded,
                          size: 28.sp,
                          color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  )
                      : Container(
                    width: 80.w,
                    height: 80.h,
                    color: Colors.white.withValues(alpha: 0.2),
                    child: Icon(Icons.fitness_center_rounded,
                        size: 28.sp,
                        color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  // Subtle overlay for better text contrast
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          getCardColor().withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        _Pill(
                          'EQP: ${exercise.equipment.toTitleCase()}',
                          backgroundColor: Colors.white.withValues(alpha: 0.4),
                          textColor: AppColors.secondaryTextColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.chevron_right_rounded,
                    color: AppColors.secondaryTextColor, size: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color? backgroundColor;

  const _Pill(
      this.text, {
        this.textColor = Colors.white,
        this.backgroundColor,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
// ── Empty State ──────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final Color color;
  const _EmptyState({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(Icons.fitness_center_rounded,
                size: 36, color: AppColors.primaryTextColor),
          ),
          SizedBox(height: 20.h),
          Text(
            'No exercises found',
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Try a different difficulty level.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.5),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
