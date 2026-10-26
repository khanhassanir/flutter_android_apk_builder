import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/models/exercise.dart';
import 'package:physioai/features/exercises/exercise_detail_screen.dart';
import 'package:physioai/providers/exercise_provider.dart';
import 'package:provider/provider.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({super.key});

  @override
  Widget build(BuildContext context) {
    final inProgress = context.watch<ExerciseProvider>().inProgressExercise;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: inProgress != null
          ? _InProgressCard(
              key: const ValueKey('in_progress'), exercise: inProgress)
          : _IdleCard(key: const ValueKey('idle')),
    );
  }
}

// ── In-Progress Card ──────────────────────────────────────────────

class _InProgressCard extends StatelessWidget {
  final Exercise exercise;

  const _InProgressCard({super.key, required this.exercise});

  static const _areaIcons = <String, IconData>{
    'neck': Icons.accessibility_new_rounded,
    'shoulders': Icons.accessibility_rounded,
    'upper_back': Icons.airline_seat_recline_extra_rounded,
    'lower_back': Icons.self_improvement_rounded,
    'hips': Icons.directions_walk_rounded,
    'knees': Icons.directions_run_rounded,
    'ankles': Icons.sports_gymnastics_rounded,
  };

  static const _areaColors = <String, Color>{
    'neck': AppColors.recentSessionCard,
    'shoulders': AppColors.aiSugesstionCard,
    'upper_back': AppColors.dailyAssessment,
    'lower_back': AppColors.socialCard,
    'hips': AppColors.recentSessionCard,
    'knees': AppColors.aiSugesstionCard,
    'ankles': AppColors.dailyAssessment,
  };

  @override
  Widget build(BuildContext context) {
    final icon =
        _areaIcons[exercise.bodyAreas.first] ?? Icons.fitness_center_rounded;
    final cardColor =
        _areaColors[exercise.bodyAreas.first] ?? AppColors.socialCard;

    return GestureDetector(
      onTap: () {
        final imageUrl = context.read<ExerciseProvider>().inProgressImageUrl;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(
              exercise: exercise,
              color: cardColor,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              color: AppColors.inProgressCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'In Progress',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.primaryTextColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${exercise.durationSeconds.toString()} Sec',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.primaryTextColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),
                // Exercise name
                Column(
                  spacing: 1.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${exercise.difficultyLabel} Level',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.secondaryTextColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      exercise.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -20.h,
            right: -15.w,
            child: Image.asset(
              "assets/gym.png",
              height: 104.h,
              width: 88.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Idle Card ─────────────────────────────────────────────────────

class _IdleCard extends StatelessWidget {
  const _IdleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 100.h,
          clipBehavior: Clip.none,
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
          decoration: BoxDecoration(
            color: AppColors.inProgressCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    'No active\nexercise',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    'Start one to track it here',
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor.withValues(alpha: 0.5),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -20.h,
          right: -15.w,
          child: Image.asset(
            "assets/gym.png",
            height: 104.h,
            width: 88.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.primaryTextColor,
          fontSize: 9.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
