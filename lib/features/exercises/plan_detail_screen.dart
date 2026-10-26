import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/exercise_data.dart';
import 'package:physioai/data/models/exercise.dart';
import 'package:physioai/data/models/exercise_plan.dart';
import 'package:physioai/features/exercises/exercise_detail_screen.dart';
import 'package:physioai/providers/exercise_provider.dart';
import 'package:physioai/providers/plan_provider.dart';
import 'package:provider/provider.dart';

class PlanDetailScreen extends StatelessWidget {
  final ExercisePlan plan;
  final Color color;

  const PlanDetailScreen({
    super.key,
    required this.plan,
    required this.color,
  });

  Color get _difficultyColor {
    switch (plan.difficulty) {
      case 'gentle':
        return AppColors.beginnerBadge;
      case 'active':
        return AppColors.intermediateBadge;
      case 'strengthening':
        return AppColors.advancedBadge;
      default:
        return AppColors.primaryTextColor;
    }
  }

  static String _formatUnlockDate(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, planProvider, _) {
        // Rebuild when exercises are marked done so the progress ring updates
        // immediately without requiring the user to navigate away.
        context.watch<ExerciseProvider>();

        final isEnrolled = planProvider.isEnrolledIn(plan.id);
        final completedDays = isEnrolled
            ? (planProvider.activeEnrollment?.completedDays ?? const <int>[])
            : const <int>[];
        final todayDay = isEnrolled ? planProvider.todayDayNumber : null;
        final enrollmentStart =
            isEnrolled ? planProvider.activeEnrollment?.startDate : null;

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
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildTopBar(context, planProvider, isEnrolled),
                      const Divider(
                          color: AppColors.divider, height: 1, thickness: 1),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 160.h),
                          children: [
                            SizedBox(height: 20.h),
                            _buildHeader(isEnrolled, planProvider, context),
                            SizedBox(height: 20.h),
                            _buildPhaseTimeline(),
                            SizedBox(height: 24.h),
                            _buildDaysList(
                              context,
                              completedDays,
                              todayDay,
                              enrollmentStart,
                              planProvider,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildCTABar(context, planProvider, isEnrolled),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Top Bar ─────────────────────────────────────────────────────

  Widget _buildTopBar(
      BuildContext context, PlanProvider planProvider, bool isEnrolled) {
    final completedCount =
        planProvider.activeEnrollment?.completedDays.length ?? 0;
    final isAllDone = isEnrolled && completedCount >= plan.durationDays;
    final todayDay = isEnrolled ? planProvider.todayDayNumber : null;
    final progress = planProvider.progressPercent;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Row(
        children: [
          // Back button
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
          SizedBox(width: 10.w),
          // Plan name pill
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                plan.name,
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Progress + cancel pill — only when enrolled
        ],
      ),
    );
  }

  // ── Header Card ──────────────────────────────────────────────

  Widget _buildHeader(
      bool isEnrolled, PlanProvider planProvider, BuildContext context) {
    final completedCount =
        planProvider.activeEnrollment?.completedDays.length ?? 0;
    final isAllDone = isEnrolled && completedCount >= plan.durationDays;
    final todayDay = isEnrolled ? planProvider.todayDayNumber : null;
    final progress = planProvider.progressPercent;

    return Column(
      children: [
        if (isEnrolled) ...[
          SizedBox(width: 10.w),
          if (isAllDone)
            // Plan complete chip
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(50),
                border:
                    Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.celebration_rounded,
                  color: AppColors.success, size: 20.sp),
            )
          else
            // Ring + day count + divider + cancel
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mini progress ring
                      SizedBox(
                        width: 48.w,
                        height: 48.h,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              backgroundColor: color,
                              valueColor: AlwaysStoppedAnimation(
                                  AppColors.primaryTextColor),
                              strokeWidth: 10.r,
                            ),
                            Center(
                              child: Text(
                                '${(progress * 100).round()}%',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.primaryTextColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Day count
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 0.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isEnrolled) ...[
                            SizedBox(width: 4.w),
                             Text(
                                'Active Plan',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.primaryTextColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                          ],
                          Text(
                            'Day $todayDay of ${plan.durationDays}',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.primaryTextColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => const _AbandonDialog(),
                      );
                      if (confirm == true) {
                        await planProvider.abandonPlan();
                        navigator.pop();
                      }
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 48.sp,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _StatChip(
              icon: Icons.calendar_today_rounded,
              label: '${plan.durationDays} days',
            ),
            SizedBox(width: 8.w),
            _StatChip(
              icon: Icons.fitness_center_rounded,
              label: '${plan.totalExercises} exercises',
            ),
            SizedBox(width: 8.w),
            _StatChip(
              icon: Icons.hotel_rounded,
              label: '${plan.restDayCount} rest days',
            ),
           // SizedBox(width: 2.w),
           /* _StatChip(
              icon: Icons.layers_rounded,
              label: '${plan.phases.length} phases',
            ),*/
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            _StatChip(
              icon: Icons.layers_rounded,
              label: '${plan.phases.length} phases',
            ),
            SizedBox(width: 8.w),
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _difficultyColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: _difficultyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    plan.difficultyLabel,
                    style: GoogleFonts.dmSans(
                      color: _difficultyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        SizedBox(height: 20.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
            /*border: isEnrolled
                ? Border.all(
                    color: AppColors.success.withValues(alpha: 0.4), width: 1.5)
                : Border.all(color: Colors.white.withValues(alpha: 0.5)),*/
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      plan.targetArea,
                      style: GoogleFonts.dmSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                ],
              ),*/
              //SizedBox(height: 12.h),
              Text(
                plan.description,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  // ── Phase Timeline ─────────────────────────────────────────────

  Widget _buildPhaseTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clinical Phases',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.primaryTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: plan.phases.asMap().entries.map((e) {
            final i = e.key;
            final phase = e.value;
            final isLast = i == plan.phases.length - 1;
            return Expanded(
              child: Row(
                children: [
                  Expanded(child: _PhaseChip(phase: phase, index: i)),
                  if (!isLast)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14.sp,
                        color:
                            AppColors.primaryTextColor.withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Day-by-Day List ────────────────────────────────────────────

  Widget _buildDaysList(
    BuildContext context,
    List<int> completedDays,
    int? todayDay,
    DateTime? enrollmentStartDate,
    PlanProvider planProvider,
  ) {
    String? currentPhase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day-by-Day Schedule',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.primaryTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.h),
        ...plan.days.map((day) {
          final showPhaseHeader = day.phaseName != currentPhase;
          currentPhase = day.phaseName;

          final isCompleted = completedDays.contains(day.dayNumber);
          final isToday = todayDay == day.dayNumber;
          final isLocked = planProvider.isDayLocked(plan.id, day.dayNumber);
          final isMissed = planProvider.isDayMissed(plan.id, day.dayNumber);

          // Compute unlock date label for locked days
          String? unlockDateLabel;
          if (isLocked && enrollmentStartDate != null) {
            final unlockDate = _dateOnly(enrollmentStartDate)
                .add(Duration(days: day.dayNumber - 1));
            unlockDateLabel = _formatUnlockDate(unlockDate);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showPhaseHeader) ...[
                if (day.dayNumber > 1) SizedBox(height: 12.h),
                _PhaseDivider(phaseName: day.phaseName),
                SizedBox(height: 8.h),
              ],
              _DayCard(
                day: day,
                color: color,
                isCompleted: isCompleted,
                isToday: isToday,
                isLocked: isLocked,
                isMissed: isMissed,
                unlockDateLabel: unlockDateLabel,
                onExerciseTap: isLocked
                    ? null
                    : (exercise) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ExerciseDetailScreen(
                              exercise: exercise,
                              color: color,
                              fromPlan: true,
                            ),
                          ),
                        );
                      },
              ),
            ],
          );
        }),
      ],
    );
  }

  // ── CTA Bar ────────────────────────────────────────────────────

  Widget _buildCTABar(
      BuildContext context, PlanProvider planProvider, bool isEnrolled) {
    final hasOtherActive = planProvider.activeEnrollment != null && !isEnrolled;
    final isTodayDone = isEnrolled && planProvider.isTodayComplete;
    final completedCount =
        planProvider.activeEnrollment?.completedDays.length ?? 0;
    final isAllDone = isEnrolled && completedCount >= plan.durationDays;
    final todayDay = planProvider.todayDayNumber;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 36.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isAllDone
          ? _CTAButton(
              label: 'Plan Completed!',
              icon: Icons.celebration_rounded,
              backgroundColor: AppColors.success.withValues(alpha: 0.12),
              textColor: AppColors.success,
              onTap: null,
            )
          : isTodayDone
              ? _CTAButton(
                  label: 'Day $todayDay Complete ✓',
                  icon: Icons.check_circle_rounded,
                  backgroundColor: AppColors.success.withValues(alpha: 0.12),
                  textColor: AppColors.success,
                  onTap: null,
                )
              : isEnrolled
                  ? _CTAButton(
                      label: 'Mark Today Complete',
                      icon: Icons.check_rounded,
                      backgroundColor: AppColors.primaryTextColor,
                      textColor: Colors.white,
                      onTap: () => planProvider.markTodayComplete(),
                    )
                  : hasOtherActive
                      ? Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: AppColors.intermediateBadge
                                .withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.intermediateBadge
                                    .withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: AppColors.intermediateBadge
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.lock_outline_rounded,
                                    size: 20.sp,
                                    color: AppColors.intermediateBadge),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Another plan is active',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.intermediateBadge,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Cancel your current plan first to start this one',
                                      style: GoogleFonts.dmSans(
                                        color: AppColors.primaryTextColor
                                            .withValues(alpha: 0.5),
                                        fontSize: 11.sp,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : _CTAButton(
                          label: 'Start Plan',
                          icon: Icons.play_circle_fill_rounded,
                          backgroundColor: AppColors.primaryTextColor,
                          textColor: Colors.white,
                          onTap: () => planProvider.startPlan(plan.id),
                        ),
    );
  }
}

// ── CTA Button ──────────────────────────────────────────────────

class _CTAButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const _CTAButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: textColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Abandon Dialog ──────────────────────────────────────────────

class _AbandonDialog extends StatelessWidget {
  const _AbandonDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Cancel This Plan?',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
        ),
      ),
      content: Text(
        'Your progress will be lost. You can restart the plan anytime.',
        style: GoogleFonts.dmSans(fontSize: 14.sp),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Keep Plan',
            style: GoogleFonts.dmSans(color: AppColors.primaryTextColor),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Cancel Plan',
            style: GoogleFonts.dmSans(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Stat Chip ───────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4)
          )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.primaryTextColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Phase Chip ──────────────────────────────────────────────────

class _PhaseChip extends StatelessWidget {
  final PlanPhase phase;
  final int index;

  const _PhaseChip({required this.phase, required this.index});

  static const _phaseColors = [
    AppColors.beginnerBadge,
    AppColors.intermediateBadge,
    AppColors.advancedBadge,
  ];

  static const _phaseIcons = [
    Icons.spa_rounded,
    Icons.trending_up_rounded,
    Icons.fitness_center_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final phaseColor = _phaseColors[index % 3];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: phaseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: phaseColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(_phaseIcons[index % 3], size: 18.sp, color: phaseColor),
          SizedBox(height: 4.h),
          Text(
            phase.name,
            style: GoogleFonts.dmSans(
              color: phaseColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Days ${phase.startDay}–${phase.endDay}',
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.4),
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Phase Divider ───────────────────────────────────────────────

class _PhaseDivider extends StatelessWidget {
  final String phaseName;

  const _PhaseDivider({required this.phaseName});

  Color get _phaseColor {
    switch (phaseName) {
      case 'Pain Relief':
        return AppColors.beginnerBadge;
      case 'Recovery':
        return AppColors.intermediateBadge;
      case 'Strengthening':
        return AppColors.advancedBadge;
      default:
        return AppColors.primaryTextColor;
    }
  }

  IconData get _phaseIcon {
    switch (phaseName) {
      case 'Pain Relief':
        return Icons.spa_rounded;
      case 'Recovery':
        return Icons.trending_up_rounded;
      case 'Strengthening':
        return Icons.fitness_center_rounded;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_phaseIcon, size: 14.sp, color: _phaseColor),
        SizedBox(width: 6.w),
        Text(
          phaseName,
          style: GoogleFonts.plusJakartaSans(
            color: _phaseColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            height: 1,
            color: _phaseColor.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}

// ── Day Card ────────────────────────────────────────────────────

class _DayCard extends StatelessWidget {
  final PlanDay day;
  final Color color;
  final bool isCompleted;
  final bool isToday;
  final bool isLocked;
  final bool isMissed;
  final String? unlockDateLabel;
  final void Function(Exercise exercise)? onExerciseTap;

  const _DayCard({
    required this.day,
    required this.color,
    required this.isCompleted,
    required this.isToday,
    required this.isLocked,
    required this.isMissed,
    required this.onExerciseTap,
    this.unlockDateLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (day.isRest) {
      return _RestDayCard(
        dayNumber: day.dayNumber,
        isCompleted: isCompleted,
        isToday: isToday,
        isLocked: isLocked,
      );
    }

    final exercises = day.exerciseIds
        .map((id) => findExerciseById(id))
        .where((e) => e != null)
        .cast<Exercise>()
        .toList();

    Color borderColor = Colors.transparent;
    double borderWidth = 0;
    if (isToday) {
      borderColor = color;
      borderWidth = 2;
    } else if (isMissed) {
      borderColor = AppColors.intermediateBadge.withValues(alpha: 0.4);
      borderWidth = 1.5;
    } else if (isCompleted) {
      borderColor = AppColors.success.withValues(alpha: 0.25);
      borderWidth = 1;
    }

    Color cardBg = Colors.white;
    if (isLocked) cardBg = Colors.white.withValues(alpha: 0.45);
    if (isCompleted) cardBg = AppColors.success.withValues(alpha: 0.06);
    if (isMissed) cardBg = AppColors.intermediateBadge.withValues(alpha: 0.05);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: borderWidth > 0
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Day header ────────────────────────────────────
          Row(
            children: [
              _DayBadge(
                dayNumber: day.dayNumber,
                color: color,
                isCompleted: isCompleted,
                isToday: isToday,
                isLocked: isLocked,
                isMissed: isMissed,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day ${day.dayNumber}',
                      style: GoogleFonts.plusJakartaSans(
                        color: isLocked
                            ? AppColors.primaryTextColor.withValues(alpha: 0.3)
                            : isCompleted
                                ? AppColors.primaryTextColor
                                    .withValues(alpha: 0.5)
                                : AppColors.primaryTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      isLocked
                          ? '${exercises.length} exercises'
                          : '${exercises.length} exercises · ~${day.estimatedMinutes} min',
                      style: GoogleFonts.dmSans(
                        color:
                            AppColors.primaryTextColor.withValues(alpha: 0.4),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // State badge (TODAY / MISSED)
              if (isToday)
                _StateBadge(label: 'TODAY', color: color)
              else if (isMissed)
                _StateBadge(
                    label: 'MISSED',
                    color: AppColors.intermediateBadge.withValues(alpha: 0.15),
                    textColor: AppColors.intermediateBadge)
              else if (isLocked)
                Icon(Icons.lock_rounded,
                    size: 16.sp,
                    color: AppColors.primaryTextColor.withValues(alpha: 0.2)),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Locked state: show unlock date ────────────────
          if (isLocked)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.primaryTextColor.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule_rounded,
                      size: 14.sp,
                      color: AppColors.primaryTextColor.withValues(alpha: 0.3)),
                  SizedBox(width: 8.w),
                  Text(
                    unlockDateLabel != null
                        ? 'Unlocks $unlockDateLabel'
                        : 'Complete previous days to unlock',
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor.withValues(alpha: 0.35),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )

          // ── Normal / missed / completed: exercise list ─────
          else
            ...exercises.asMap().entries.map((entry) {
              final exercise = entry.value;
              return GestureDetector(
                onTap: onExerciseTap != null
                    ? () => onExerciseTap!(exercise)
                    : null,
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: entry.key < exercises.length - 1 ? 8.h : 0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.success.withValues(alpha: 0.08)
                        : isMissed
                            ? AppColors.intermediateBadge
                                .withValues(alpha: 0.07)
                            : color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isCompleted
                              ? Icons.check_rounded
                              : Icons.play_arrow_rounded,
                          size: 16.sp,
                          color: isCompleted
                              ? AppColors.success
                              : AppColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: GoogleFonts.dmSans(
                                color: isCompleted
                                    ? AppColors.primaryTextColor
                                        .withValues(alpha: 0.5)
                                    : AppColors.primaryTextColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${exercise.durationLabel} · ${exercise.sets} sets',
                              style: GoogleFonts.dmSans(
                                color: AppColors.primaryTextColor
                                    .withValues(alpha: 0.4),
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16.sp,
                        color:
                            AppColors.primaryTextColor.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

// ── Day Badge ────────────────────────────────────────────────────

class _DayBadge extends StatelessWidget {
  final int dayNumber;
  final Color color;
  final bool isCompleted;
  final bool isToday;
  final bool isLocked;
  final bool isMissed;

  const _DayBadge({
    required this.dayNumber,
    required this.color,
    required this.isCompleted,
    required this.isToday,
    required this.isLocked,
    required this.isMissed,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Widget child;

    if (isCompleted) {
      bg = AppColors.success.withValues(alpha: 0.15);
      child = Icon(Icons.check_rounded, color: AppColors.success, size: 18.sp);
    } else if (isToday) {
      bg = color;
      child = Text(
        '$dayNumber',
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.primaryTextColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w800,
        ),
      );
    } else if (isLocked) {
      bg = AppColors.primaryTextColor.withValues(alpha: 0.06);
      child = Icon(Icons.lock_rounded,
          color: AppColors.primaryTextColor.withValues(alpha: 0.2),
          size: 16.sp);
    } else if (isMissed) {
      bg = AppColors.intermediateBadge.withValues(alpha: 0.12);
      child = Text(
        '$dayNumber',
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.intermediateBadge,
          fontSize: 15.sp,
          fontWeight: FontWeight.w800,
        ),
      );
    } else {
      bg = color.withValues(alpha: 0.3);
      child = Text(
        '$dayNumber',
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.primaryTextColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: child),
    );
  }
}

// ── State Badge (TODAY / MISSED) ─────────────────────────────────

class _StateBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const _StateBadge({required this.label, required this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          color: textColor ?? AppColors.primaryTextColor,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Rest Day Card ───────────────────────────────────────────────

class _RestDayCard extends StatelessWidget {
  final int dayNumber;
  final bool isCompleted;
  final bool isToday;
  final bool isLocked;

  const _RestDayCard({
    required this.dayNumber,
    required this.isCompleted,
    required this.isToday,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLocked
            ? Colors.white.withValues(alpha: 0.4)
            : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? AppColors.success.withValues(alpha: 0.25)
              : AppColors.primaryTextColor.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: isLocked
                  ? AppColors.primaryTextColor.withValues(alpha: 0.06)
                  : isCompleted
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.inProgressCard.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: isLocked
                ? Icon(Icons.lock_rounded,
                    size: 16.sp,
                    color: AppColors.primaryTextColor.withValues(alpha: 0.2))
                : isCompleted
                    ? Icon(Icons.check_rounded,
                        color: AppColors.success, size: 18.sp)
                    : Center(
                        child: Text(
                          '$dayNumber',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryTextColor
                                .withValues(alpha: 0.6),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day $dayNumber — Rest Day',
                  style: GoogleFonts.plusJakartaSans(
                    color: isLocked
                        ? AppColors.primaryTextColor.withValues(alpha: 0.3)
                        : AppColors.primaryTextColor.withValues(alpha: 0.6),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  isLocked
                      ? 'Your future recovery day'
                      : 'Your body recovers and adapts during rest',
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.35),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isLocked ? Icons.lock_rounded : Icons.hotel_rounded,
            size: 20.sp,
            color: AppColors.primaryTextColor.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
