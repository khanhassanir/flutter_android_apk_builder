import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/exercise_data.dart';
import 'package:physioai/data/models/exercise.dart';
import 'package:physioai/features/exercises/exercise_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String areaKey;
  final String label;
  final Color color;

  const CategoryScreen({
    super.key,
    required this.areaKey,
    required this.label,
    required this.color,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _difficulty = 'all';

  List<Exercise> get _filtered {
    final base = widget.areaKey == 'full_body'
        ? exerciseData.where((e) => e.bodyAreas.length > 1).toList()
        : exerciseData.where((e) => e.bodyAreas.contains(widget.areaKey)).toList();
    if (_difficulty == 'all') return base;
    return base.where((e) => e.difficulty == _difficulty).toList();
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
              _TopBar(label: widget.label),
              const Divider(color: AppColors.divider, height: 1, thickness: 1),
              _FilterRow(
                selected: _difficulty,
                onChanged: (d) => setState(() => _difficulty = d),
              ),
              Expanded(
                child: _filtered.isEmpty
                    ? _EmptyState(color: widget.color)
                    : ListView.builder(
                        padding:
                            EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                        itemCount: _filtered.length,
                        itemBuilder: (context, i) => _ExerciseItem(
                          exercise: _filtered[i],
                          color: widget.color,
                          index: i,
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
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded,
                  color: AppColors.primaryTextColor, size: 22.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2)),
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

// ── Difficulty Filter Row ────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;

  static const _filters = [
    ('all', 'All'),
    ('beginner', 'Beginner'),
    ('intermediate', 'Intermediate'),
    ('advanced', 'Advanced'),
  ];

  const _FilterRow({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final (key, label) = _filters[i];
          final isSelected = selected == key;
          return SizedBox(
            child: GestureDetector(
              onTap: () => onChanged(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryTextColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2)),
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
            ),
          );
        },
      ),
    );
  }
}

// ── Exercise Item ─────────────────────────────────────────────────

class _ExerciseItem extends StatelessWidget {
  final Exercise exercise;
  final Color color;
  final int index;

  static const _difficultyColors = <String, Color>{
    'beginner': AppColors.recentSessionCard,
    'intermediate': AppColors.aiSugesstionCard,
    'advanced': AppColors.dailyAssessment,
  };

  static const _areaIcons = <String, IconData>{
    'neck': Icons.accessibility_new_rounded,
    'shoulders': Icons.accessibility_rounded,
    'upper_back': Icons.airline_seat_recline_extra_rounded,
    'lower_back': Icons.self_improvement_rounded,
    'hips': Icons.directions_walk_rounded,
    'knees': Icons.directions_run_rounded,
    'ankles': Icons.sports_gymnastics_rounded,
  };

  const _ExerciseItem({
    required this.exercise,
    required this.color,
    required this.index,
  });

  Color get _difficultyColor => switch (exercise.difficulty) {
        'beginner' => AppColors.beginnerBadge,
        'intermediate' => AppColors.intermediateBadge,
        _ => AppColors.advancedBadge,
      };

  @override
  Widget build(BuildContext context) {
    final cardColor =
        _difficultyColors[exercise.difficulty] ?? AppColors.socialCard;
    final areaIcon =
        _areaIcons[exercise.bodyAreas.first] ?? Icons.fitness_center_rounded;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(exercise: exercise, color: cardColor),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(areaIcon,
                  size: 22.sp, color: AppColors.primaryTextColor),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      _Pill(
                        exercise.difficultyLabel,
                        textColor: _difficultyColor,
                      ),
                      SizedBox(width: 6.w),
                      _Pill(exercise.durationLabel),
                      SizedBox(width: 6.w),
                      _Pill('${exercise.sets} sets'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.chevron_right_rounded,
                  color: AppColors.primaryTextColor, size: 18.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color? textColor;
  const _Pill(this.label, {this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          color: textColor ?? AppColors.primaryTextColor,
          fontSize: 10.sp,
          fontWeight: textColor == null ? FontWeight.w600 : FontWeight.w800,
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
