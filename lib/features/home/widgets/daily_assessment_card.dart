import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/features/assessment/daily_assessment_screen.dart';
import 'package:physioai/providers/progress_provider.dart';
import 'package:provider/provider.dart';

class DailyAssessmentCard extends StatelessWidget {
  const DailyAssessmentCard({super.key});

  static String _subtitle(ProgressProvider p) {
    final pain = p.todayCheckIn;
    final streak = p.currentStreak;
    if (pain != null) {
      if (streak >= 3) {
        return '$streak day streak · Pain today: $pain/10';
      }
      return 'Pain today: $pain/10 · Check-in done';
    }
    if (streak >= 2) {
      return '$streak day streak — log today\nto continue';
    }
    return 'Tap to log today\'s pain & get\nyour insight';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DailyAssessmentScreen()),
        );
      },
      child: Consumer<ProgressProvider>(
        builder: (context, progress, _) {
          final subtitle = _subtitle(progress);
          final doneToday = progress.todayCheckIn != null;

          return Container(
            height: 184.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      height: 130.h,
                      decoration: BoxDecoration(
                        color: AppColors.dailyAssessment,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 36.w,
                  top: 54.h,
                  child: Text(
                    'Daily',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Positioned(
                  left: 36.w,
                  top: 82.h,
                  child: Text(
                    'assessment',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Positioned(
                  left: 36.w,
                  top: 122.h,
                  child: Row(
                    children: [
                      if (doneToday)
                        Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 12.sp,
                            color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                          ),
                        ),
                      Text(
                        subtitle,
                        style: GoogleFonts.dmSans(
                          color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 18,
                  right: 24,
                  child: Image.asset(
                    "assets/daily_assessment_icon.png",
                    height: 160.h,
                    width: 128.w,
                    fit: BoxFit.cover,
                  )
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
