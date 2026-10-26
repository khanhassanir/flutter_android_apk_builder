import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/core/utils/app_localizations.dart';
import 'package:physioai/data/exercise_data.dart';
import 'package:physioai/data/models/assessment_result.dart';
import 'package:physioai/data/models/exercise.dart';
import 'package:physioai/features/exercises/exercise_detail_screen.dart';
import 'package:physioai/providers/assessment_provider.dart';
import 'package:provider/provider.dart';

class AllSessionsScreen extends StatelessWidget {
  const AllSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assessments = context.watch<AssessmentProvider>().allAssessments;

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
              _TopBar(),
              const Divider(color: AppColors.divider, height: 1, thickness: 1),
              Expanded(
                child: assessments.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h),
                        itemCount: assessments.length,
                        itemBuilder: (context, index) => _SessionItem(
                          result: assessments[index],
                          colorIndex: index,
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

// ── Top Bar ────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 50,
              height: 50,
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
                  color: AppColors.primaryTextColor, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
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
              'All Sessions',
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Session Item ───────────────────────────────────────────────

class _SessionItem extends StatelessWidget {
  final AssessmentResult result;
  final int colorIndex;

  static const _cardColors = [
    AppColors.recentSessionCard,
    AppColors.aiSugesstionCard,
    AppColors.dailyAssessment,
    AppColors.socialCard,
  ];

  const _SessionItem({required this.result, required this.colorIndex});

  void _openDetail(BuildContext context, Color cardColor) {
    final exercises = result.exerciseIds
        .map(findExerciseById)
        .whereType<Exercise>()
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SessionDetailSheet(
        result: result,
        cardColor: cardColor,
        exercises: exercises,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _cardColors[colorIndex % _cardColors.length];

    return GestureDetector(
      onTap: () => _openDetail(context, cardColor),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.areaLabel(result.area),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    result.diagnosis,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: [
                      if (result.source != 'chat')
                        _Pill('${result.confidence}% match'),
                      if (result.source != 'chat')
                        _Pill(_painLabel(result.painType)),
                      _SourcePill(_sourceLabel(result.source)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('dd MMM').format(result.date),
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  DateFormat('yyyy').format(result.date),
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (result.source != 'chat') ...[
                  SizedBox(height: 10.h),
                  _Pill('Pain ${result.intensity}/10'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _painLabel(String type) {
    const map = {
      'sharp': 'Sharp',
      'dull': 'Dull',
      'burning': 'Burning',
      'stiffness': 'Stiffness',
      'throbbing': 'Throbbing',
    };
    return map[type] ?? type;
  }

  static String _sourceLabel(String source) {
    const map = {
      'chat': 'Chat Diagnosis',
      'ai': 'AI Assessment',
      'app_assessment': 'App Assessment',
    };
    return map[source] ?? source;
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.primaryTextColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SourcePill extends StatelessWidget {
  final String label;
  const _SourcePill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryTextColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryTextColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.primaryTextColor.withValues(alpha: 0.75),
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Session Detail Sheet ───────────────────────────────────────

class _SessionDetailSheet extends StatelessWidget {
  final AssessmentResult result;
  final Color cardColor;
  final List<Exercise> exercises;

  const _SessionDetailSheet({
    required this.result,
    required this.cardColor,
    required this.exercises,
  });

  static String _sourceLabel(String source) {
    const map = {
      'chat': 'Chat Diagnosis',
      'ai': 'AI Assessment',
      'app_assessment': 'App Assessment',
    };
    return map[source] ?? source;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 24.h + bottomPad),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ────────────────────────────────────
          SizedBox(height: 12.h),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16.h),

          // ── Header card ────────────────────────────────────
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.areaLabel(result.area),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryTextColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _sourceLabel(result.source),
                        style: GoogleFonts.dmSans(
                          color: AppColors.primaryTextColor
                              .withValues(alpha: 0.55),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(result.date),
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // ── Diagnosis text ─────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagnosis',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  result.diagnosis,
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.65),
                    fontSize: 13.sp,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // ── Exercises section ──────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  'Recommended Exercises',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTextColor
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${exercises.length}',
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor
                          .withValues(alpha: 0.55),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          if (exercises.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
              child: Text(
                'No exercises were recommended in this session.',
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.4),
                  fontSize: 13.sp,
                ),
              ),
            )
          else
            ...exercises.map(
              (ex) => _ExerciseRow(exercise: ex, cardColor: cardColor),
            ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

// ── Exercise row inside the detail sheet ───────────────────────

class _ExerciseRow extends StatelessWidget {
  final Exercise exercise;
  final Color cardColor;

  const _ExerciseRow({required this.exercise, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(
            exercise: exercise,
            color: cardColor,
            fromChat: true,
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.fitness_center_rounded,
                  size: 16.sp, color: AppColors.primaryTextColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${exercise.sets} sets · ${exercise.repsOrHold} · ${exercise.durationLabel}',
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor
                          .withValues(alpha: 0.45),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18.sp,
                color: AppColors.primaryTextColor.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
              color: AppColors.recentSessionCard,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(Icons.history_rounded,
                size: 36, color: AppColors.primaryTextColor),
          ),
          SizedBox(height: 20.h),
          Text(
            'No sessions yet',
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Complete an assessment to see\nyour session history here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
