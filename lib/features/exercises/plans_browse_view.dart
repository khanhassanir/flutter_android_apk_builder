import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/models/exercise_plan.dart';
import 'package:physioai/data/plan_data.dart';
import 'package:physioai/features/exercises/plan_detail_screen.dart';
import 'package:physioai/providers/plan_provider.dart';
import 'package:provider/provider.dart';

class PlansBrowseView extends StatefulWidget {
  /// Set [standalone] to true when pushing as a full route via Navigator.
  /// Leave false (default) when embedding inside another scaffold.
  final bool standalone;
  const PlansBrowseView({super.key, this.standalone = false});

  @override
  State<PlansBrowseView> createState() => _PlansBrowseViewState();
}

class _PlansBrowseViewState extends State<PlansBrowseView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _cardColors = [
    AppColors.recentSessionCard,
    AppColors.aiSugesstionCard,
    AppColors.dailyAssessment,
    AppColors.socialCard,
  ];

  static const _tabMeta = [
    (label: 'Quick', icon: Icons.bolt_rounded, subtitle: '7-day programs'),
    (
      label: 'Focused',
      icon: Icons.trending_up_rounded,
      subtitle: '14-day programs'
    ),
    (
      label: 'Transformation',
      icon: Icons.auto_awesome_rounded,
      subtitle: '21-day programs'
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortPlans = planData.where((p) => p.durationDays <= 7).toList();
    final mediumPlans =
        planData.where((p) => p.durationDays > 7 && p.durationDays <= 14).toList();
    final longPlans = planData.where((p) => p.durationDays > 14).toList();

    return Consumer<PlanProvider>(
      builder: (context, planProvider, _) {
        final activePlanId = planProvider.activeEnrollment?.planId;

        final body = Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPlanList(context, shortPlans, activePlanId, 0),
                  _buildPlanList(context, mediumPlans, activePlanId, 1),
                  _buildPlanList(context, longPlans, activePlanId, 2),
                ],
              ),
            ),
          ],
        );

        if (!widget.standalone) return body;

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
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 8.h),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 46.w,
                            height: 46.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2)),
                              ],
                            ),
                            child: Icon(Icons.arrow_back_rounded,
                                color: AppColors.primaryTextColor, size: 20.sp),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Text(
                          'Recovery Plans',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryTextColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                      color: AppColors.divider, height: 1, thickness: 1),
                  Expanded(child: body),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Custom pill tab bar ────────────────────────────────────────

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 4.h),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.primaryTextColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: List.generate(3, (i) {
            final selected = _tabController.index == i;
            final meta = _tabMeta[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => _tabController.animateTo(i),
                child: AnimatedContainer(
                  height: 30.h,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primaryTextColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryTextColor
                                  .withValues(alpha: 0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Icon(
                        meta.icon,
                        size: 14.sp,
                        color: selected
                            ? Colors.white
                            : AppColors.primaryTextColor
                                .withValues(alpha: 0.45),
                      ),
                      SizedBox(width: 5.w),*/
                      Text(
                        meta.label,
                        style: GoogleFonts.plusJakartaSans(
                          color: selected
                              ? Colors.white
                              : AppColors.primaryTextColor
                                  .withValues(alpha: 0.5),
                          fontSize: 12.sp,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Plan list per tab ──────────────────────────────────────────

  Widget _buildPlanList(
    BuildContext context,
    List<ExercisePlan> plans,
    String? activePlanId,
    int tabIndex,
  ) {
    final meta = _tabMeta[tabIndex];

    if (plans.isEmpty) {
      return Center(
        child: Text(
          'No plans available',
          style: GoogleFonts.dmSans(
            color: AppColors.primaryTextColor.withValues(alpha: 0.4),
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h),
      children: [
        // Tab subtitle
        Row(
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.primaryTextColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(meta.icon, size: 16.sp, color: Colors.white),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta.label,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  meta.subtitle,
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.45),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryTextColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${plans.length} plans',
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.5),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...plans.asMap().entries.map(
              (e) => _PlanCard(
                plan: e.value,
                color: _cardColors[(e.key + tabIndex) % 4],
                isActive: activePlanId == e.value.id,
              ),
            ),
      ],
    );
  }
}

// ── Plan Card ──────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final ExercisePlan plan;
  final Color color;
  final bool isActive;

  const _PlanCard({
    required this.plan,
    required this.color,
    required this.isActive,
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

  IconData get _areaIcon {
    final area = plan.targetArea.toLowerCase();
    if (area.contains('neck')) return Icons.accessibility_new_rounded;
    if (area.contains('shoulder')) return Icons.accessibility_rounded;
    if (area.contains('back')) return Icons.self_improvement_rounded;
    if (area.contains('knee')) return Icons.directions_run_rounded;
    if (area.contains('hip') || area.contains('core')) {
      return Icons.directions_walk_rounded;
    }
    if (area.contains('full')) return Icons.fitness_center_rounded;
    return Icons.fitness_center_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PlanDetailScreen(plan: plan, color: color),
        ),
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24.0.w),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(14.w, 16.h, 16.w, 16.h),
                      child: Row(
                        children: [
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        plan.name,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.primaryTextColor,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isActive) ...[
                                      SizedBox(width: 6.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.success
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: AppColors.success
                                                  .withValues(alpha: 0.3)),
                                        ),
                                        child: Text(
                                          'Active',
                                          style: GoogleFonts.dmSans(
                                            color: AppColors.success,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  plan.description,
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.primaryTextColor
                                        .withValues(alpha: 0.55),
                                    fontSize: 11.sp,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    _InfoPill(
                                      icon: Icons.calendar_today_rounded,
                                      label: '${plan.durationDays} days',
                                    ),
                                    SizedBox(width: 6.w),
                                    _InfoPill(
                                      icon: Icons.fitness_center_rounded,
                                      label: '${plan.totalExercises} exercises',
                                    ),
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: _difficultyColor
                                            .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        plan.difficultyLabel,
                                        style: GoogleFonts.dmSans(
                                          color: _difficultyColor,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.chevron_right_rounded,
                                color: AppColors.primaryTextColor,
                                size: 18.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -10,
            top: 12,
            child: Icon(_areaIcon,
                size: 62.sp, color: Colors.white.withValues(alpha: 0.80)),
          ),
        ],
      ),
    );
  }
}

// ── Small Info Pill ─────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: AppColors.primaryTextColor),
          SizedBox(width: 3.w),
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
