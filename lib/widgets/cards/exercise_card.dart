import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;
  final bool compact;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: compact ? EdgeInsets.zero : EdgeInsets.only(bottom: 10.w),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor2,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 14,
              offset: const Offset(2, -4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 14,
              offset: const Offset(-2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _ExerciseIcon(area: exercise.bodyAreas.first),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    exercise.targetArea,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Row(
                    children: [
                      _DifficultyBadge(difficulty: exercise.difficulty),
                      SizedBox(width: 8.w),
                      _MetaBadge(
                        icon: Icons.timer_outlined,
                        label: exercise.durationLabel,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppColors.dailyAssessment.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.chevron_right_rounded,
                  color: AppColors.primaryTextColor, size: 18.w),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseIcon extends StatelessWidget {
  final String area;
  const _ExerciseIcon({required this.area});

  static const _icons = <String, IconData>{
    'neck': Icons.accessibility_new,
    'shoulders': Icons.accessibility,
    'upper_back': Icons.airline_seat_recline_normal,
    'lower_back': Icons.self_improvement,
    'hips': Icons.directions_walk,
    'knees': Icons.directions_run,
    'ankles': Icons.sports_gymnastics,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[area] ?? Icons.fitness_center;
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.dailyAssessment.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(icon, color: AppColors.primaryTextColor, size: 23.w),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty) {
      'beginner' => AppColors.beginnerBadge,
      'intermediate' => AppColors.intermediateBadge,
      _ => AppColors.advancedBadge,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        difficulty[0].toUpperCase() + difficulty.substring(1),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.secondaryTextColor,
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.w, color: AppColors.secondaryTextColor),
         SizedBox(width: 3.w),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: AppColors.secondaryTextColor),
        ),
      ],
    );
  }
}
