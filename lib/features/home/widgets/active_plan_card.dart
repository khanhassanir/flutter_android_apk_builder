import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/plan_data.dart';
import 'package:physioai/features/exercises/plan_detail_screen.dart';
import 'package:physioai/features/exercises/plans_browse_view.dart';
import 'package:physioai/providers/exercise_provider.dart';
import 'package:physioai/providers/plan_provider.dart';
import 'package:provider/provider.dart';

class ActivePlanCard extends StatelessWidget {
  const ActivePlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, planProvider, _) {
        // Also watch ExerciseProvider so the card rebuilds when individual
        // exercises are marked done — updating partial-day progress in real time.
        context.watch<ExerciseProvider>();

        final plan = planProvider.activePlan;
        final enrollment = planProvider.activeEnrollment;

        if (plan == null || enrollment == null) {
          return _NoPlanCard();
        }

        final todayDay = planProvider.todayDayNumber ?? 1;
        final progress = planProvider.progressPercent;
        final cardColor = planCardColor(plan.id);

        final todayPlanDays =
            plan.days.where((d) => d.dayNumber == todayDay).toList();
        final todayPlanDay =
            todayPlanDays.isEmpty ? null : todayPlanDays.first;
        final isRestDay = todayPlanDay?.isRest ?? false;

        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PlanDetailScreen(plan: plan, color: cardColor),
            ),
          ),
          child: _PlanCardShell(
            cardColor: cardColor,
            progress: progress,
            progressLabel: '${(progress * 100).round()}%',
            title: plan.name,
            subtitle: isRestDay
                ? 'Day $todayDay of ${plan.durationDays} · Rest Day'
                : 'Day $todayDay of ${plan.durationDays} · ${todayPlanDay?.exerciseIds.length ?? 0} exercises',
            pillLabel: 'Active Plan',
            pillIcon: Icons.check_circle_rounded,
          ),
        );
      },
    );
  }
}

// ── No-plan empty state ───────────────────────────────────────

class _NoPlanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PlansBrowseView(standalone: true)),
      ),
      child: _PlanCardShell(
        cardColor: AppColors.recentSessionCard,
        progress: 0,
        progressLabel: '0%',
        title: 'No active plan',
        subtitle: 'Browse plans to start your recovery',
        pillLabel: 'Browse plans',
        pillIcon: Icons.arrow_forward_rounded,
      ),
    );
  }
}

// ── Shared card shell ─────────────────────────────────────────

class _PlanCardShell extends StatelessWidget {
  final Color cardColor;
  final double progress;
  final String progressLabel;
  final String title;
  final String subtitle;
  final String pillLabel;
  final IconData pillIcon;

  const _PlanCardShell({
    required this.cardColor,
    required this.progress,
    required this.progressLabel,
    required this.title,
    required this.subtitle,
    required this.pillLabel,
    required this.pillIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
      padding: EdgeInsets.fromLTRB(0.w, 4.h, 20.w, 4.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(42.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 12,
            offset: const Offset(-8, 0),
          ),
        ],
      ),
      child: Row(
        spacing: 15.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ── Circular progress ring ─────────────────────────
          SizedBox(
            width: 82.w,
            height: 82.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.95),
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.primaryTextColor),
                  strokeWidth: 8.0.r,
                ),
                Center(
                  child: Text(
                    progressLabel,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Plan info ──────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.55),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(pillIcon,
                          size: 10.sp, color: AppColors.primaryTextColor),
                      SizedBox(width: 4.w),
                      Text(
                        pillLabel,
                        style: GoogleFonts.dmSans(
                          color: AppColors.primaryTextColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
