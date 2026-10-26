import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/progress_provider.dart';

const _kGradient = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      AppColors.backgroundColor,
      AppColors.backgroundColor2,
      AppColors.backgroundColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  ),
);

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _kGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
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
                    'History',
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Divider(
                  color: AppColors.divider, height: 1, thickness: 1),
              const Expanded(child: _HistoryBody()),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────

class _HistoryBody extends StatelessWidget {
  const _HistoryBody();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
      children: [
        _StatsRow(provider: p),
        SizedBox(height: 28.h),
        _SectionLabel('Weekly Activity'),
        SizedBox(height: 14.h),
        _ActivityChart(provider: p),
        SizedBox(height: 28.h),
        _SectionLabel('AI Insights'),
        SizedBox(height: 14.h),
        ...p.aiInsights.map((insight) => _InsightCard(text: insight)),
        SizedBox(height: 20.h),
      ],
    );
  }
}

// ── Section label ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryTextColor,
      ),
    );
  }
}

// ── Stat cards ────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final ProgressProvider provider;
  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.fitness_center_rounded,
            value: provider.totalExercisesCompleted,
            label: 'Exercises\ndone',
            bgColor: AppColors.recentSessionCard,
            iconColor: const Color(0xFF2D5CB8),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            icon: Icons.route_rounded,
            value: provider.totalPlansDone,
            label: 'Plans\ndone',
            bgColor: AppColors.inProgressCard,
            iconColor: const Color(0xFF2D7A3A),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            icon: Icons.chat_bubble_rounded,
            value: provider.totalAiChats,
            label: 'AI chats\ndone',
            bgColor: AppColors.aiSugesstionCard,
            iconColor: const Color(0xFF7A4A00),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color bgColor;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 18.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.55),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 19.sp),
          ),
          SizedBox(height: 14.h),
          Text(
            '$value',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryTextColor,
              height: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor.withValues(alpha: 0.65),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Activity bar chart ────────────────────────────────────────

class _ActivityChart extends StatelessWidget {
  final ProgressProvider provider;
  const _ActivityChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    final totals = provider.weeklyActivityTotals;
    final labels = provider.weeklyDayLabels;
    final maxVal = totals.reduce((a, b) => a > b ? a : b);
    final maxY = maxVal <= 1 ? 5.0 : (maxVal + 1).toDouble();

    return Container(
      height: 200.h,
      padding: EdgeInsets.fromLTRB(4.w, 16.h, 16.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY <= 5 ? 1 : (maxY / 4).ceilToDouble(),
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.divider.withValues(alpha: 0.7),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: maxY <= 5 ? 1 : (maxY / 4).ceilToDouble(),
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}',
                  style: GoogleFonts.dmSans(
                      fontSize: 10.sp, color: AppColors.textHint),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  final isToday = i == 6;
                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      labels[i],
                      style: GoogleFonts.dmSans(
                        fontSize: 10.sp,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                        color: isToday
                            ? AppColors.dailyAssessment
                            : AppColors.textHint,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.primaryTextColor,
              getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                '${rod.toY.toInt()} activit${rod.toY.toInt() == 1 ? 'y' : 'ies'}',
                GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          barGroups: List.generate(7, (i) {
            final isToday = i == 6;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: totals[i].toDouble(),
                  width: 20.w,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ),
                  gradient: LinearGradient(
                    colors: isToday
                        ? [
                            AppColors.dailyAssessment,
                            AppColors.dailyAssessment.withValues(alpha: 0.65),
                          ]
                        : [
                            AppColors.recentSessionCard,
                            AppColors.recentSessionCard.withValues(alpha: 0.55),
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ── AI Insight card ───────────────────────────────────────────

class _InsightCard extends StatelessWidget {
  final String text;
  const _InsightCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.aiSugesstionCard.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.psychology_rounded,
              color: const Color(0xFF7A4A00),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                fontSize: 13.sp,
                color: AppColors.primaryTextColor,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
