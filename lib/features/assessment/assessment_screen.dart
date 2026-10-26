import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/widgets/common/ai_logo.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../../data/exercise_data.dart';
import '../../features/exercises/exercise_detail_screen.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/body_map/body_map_widget.dart';
import '../../widgets/cards/exercise_card.dart';

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

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return const _AssessmentView();
  }
}

class _AssessmentView extends StatelessWidget {
  const _AssessmentView();

  @override
  Widget build(BuildContext context) {
    final step = context.watch<AssessmentProvider>().step;

    return Container(
      decoration: _kGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(step: step),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  ),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOut)),
                      child: child,
                    ),
                  ),
                  child: switch (step) {
                    0 => const _AreaSelectionStep(key: ValueKey(0)),
                    1 => const _PainTypeStep(key: ValueKey(1)),
                    2 => const _IntensityStep(key: ValueKey(2)),
                    3 => const _AnalyzingStep(key: ValueKey(3)),
                    4 => const _ResultsStep(key: ValueKey(4)),
                    _ => const _AreaSelectionStep(key: ValueKey(0)),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int step;
  const _TopBar({required this.step});

  @override
  Widget build(BuildContext context) {
    final showBack = step > 0 && step < 3;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (showBack) {
                context.read<AssessmentProvider>().prevStep();
              } else {
                Navigator.of(context).pop();
              }
            },
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
              child: Icon(
                showBack
                    ? Icons.arrow_back_rounded
                    : Icons.close_rounded,
                color: AppColors.primaryTextColor,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              step >= 4 ? S.resultsTitle : S.aiAnalysis,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primaryTextColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (step < 3)
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColors.dailyAssessment.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                'Step ${step + 1} of 3',
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Step indicator (inside each step) ────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Step $current of $total',
          style: GoogleFonts.dmSans(
            color: AppColors.primaryTextColor.withValues(alpha: 0.4),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor:
                  AppColors.primaryTextColor.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation(
                  AppColors.dailyAssessment),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Primary button ────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _PrimaryButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.dailyAssessment
              : AppColors.primaryTextColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.dailyAssessment.withValues(alpha: 0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            color: enabled
                ? AppColors.primaryTextColor
                : AppColors.primaryTextColor.withValues(alpha: 0.3),
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Step 0: Area selection ────────────────────────────────────────

class _AreaSelectionStep extends StatelessWidget {
  const _AreaSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssessmentProvider>();
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepIndicator(current: 1, total: 3),
          SizedBox(height: 16.h),
          Text(
            S.selectPainArea,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            S.selectPainAreaSub,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.45),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Expanded(
            child: BodyMapWidget(
              selectedAreas: provider.selectedArea != null
                  ? {provider.selectedArea!}
                  : {},
              onAreaTapped: (area) =>
                  context.read<AssessmentProvider>().selectArea(area),
              multiSelect: false,
            ),
          ),
          SizedBox(height: 12.h),
          _PrimaryButton(
            label: S.next,
            onTap: provider.canProceedStep0
                ? () => context.read<AssessmentProvider>().nextStep()
                : null,
          ),
        ],
      ),
    );
  }
}

// ── Step 1: Pain type ─────────────────────────────────────────────

class _PainTypeStep extends StatelessWidget {
  const _PainTypeStep({super.key});

  static const _types = [
    ('sharp', Icons.bolt_rounded, 'Short stabbing pain'),
    ('dull', Icons.circle_outlined, 'Deep, aching sensation'),
    ('burning', Icons.local_fire_department_rounded, 'Hot, burning feeling'),
    ('stiffness', Icons.accessibility_new_rounded, 'Tight and restricted'),
    ('throbbing', Icons.waves_rounded, 'Pulsing pain'),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssessmentProvider>();
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepIndicator(current: 2, total: 3),
          SizedBox(height: 16.h),
          Text(
            S.selectPainType,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            S.selectPainTypeSub,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.45),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 20.h),
          ..._types.map((t) => _PainTypeCard(
                type: t.$1,
                icon: t.$2,
                description: t.$3,
                selected: provider.selectedPainType == t.$1,
                onTap: () =>
                    context.read<AssessmentProvider>().selectPainType(t.$1),
              )),
          SizedBox(height: 16.h),
          _PrimaryButton(
            label: S.next,
            onTap: provider.canProceedStep1
                ? () => context.read<AssessmentProvider>().nextStep()
                : null,
          ),
        ],
      ),
    );
  }
}

class _PainTypeCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _PainTypeCard({
    required this.type,
    required this.icon,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.dailyAssessment.withValues(alpha: 0.13)
              : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? AppColors.dailyAssessment
                : AppColors.primaryTextColor.withValues(alpha: 0.1),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.dailyAssessment.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.dailyAssessment
                    : AppColors.dailyAssessment.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                icon,
                color: selected
                    ? AppColors.primaryTextColor
                    : AppColors.primaryTextColor.withValues(alpha: 0.45),
                size: 22.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.painTypeLabel(type),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.primaryTextColor
                          : AppColors.primaryTextColor.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: GoogleFonts.dmSans(
                      fontSize: 11.sp,
                      color: AppColors.primaryTextColor.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded,
                  color: AppColors.dailyAssessment, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

// ── Step 2: Intensity + duration ──────────────────────────────────

class _IntensityStep extends StatelessWidget {
  const _IntensityStep({super.key});

  static const _durations = [
    ('today', Icons.today_outlined, S.today),
    ('few_days', Icons.calendar_view_week_outlined, S.fewDays),
    ('weeks', Icons.calendar_month_outlined, S.weeks),
    ('months', Icons.date_range_outlined, S.months),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssessmentProvider>();
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepIndicator(current: 3, total: 3),
          SizedBox(height: 16.h),
          Text(
            S.intensityQuestion,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 24.h),
          _IntensitySlider(
            value: provider.intensity,
            onChanged: (v) =>
                context.read<AssessmentProvider>().setIntensity(v),
          ),
          SizedBox(height: 28.h),
          Text(
            S.durationQuestion,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'How long have you had this pain?',
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.45),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.8,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            children: _durations
                .map((d) => _DurationCard(
                      key: ValueKey(d.$1),
                      value: d.$1,
                      icon: d.$2,
                      label: d.$3,
                      selected: provider.duration == d.$1,
                      onTap: () =>
                          context.read<AssessmentProvider>().setDuration(d.$1),
                    ))
                .toList(),
          ),
          SizedBox(height: 28.h),
          _PrimaryButton(
            label: S.next,
            onTap: provider.canProceedStep2
                ? () {
                    final age =
                        context.read<UserProvider>().profile?.age ?? 30;
                    context.read<AssessmentProvider>().nextStep();
                    context.read<AssessmentProvider>().analyze(age);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _IntensitySlider extends StatelessWidget {
  final int value;
  final void Function(int) onChanged;

  const _IntensitySlider({required this.value, required this.onChanged});

  Color _color(int v) {
    if (v <= 3) return AppColors.success;
    if (v <= 6) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pain intensity',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _color(value).withValues(alpha: 0.1),
                  border: Border.all(
                    color: _color(value).withValues(alpha: 0.4),
                    width: 2.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: _color(value),
                      ),
                    ),
                    Text(
                      '/ 10',
                      style: GoogleFonts.dmSans(
                        fontSize: 9.sp,
                        color: _color(value).withValues(alpha: 0.65),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _color(value),
              thumbColor: _color(value),
              overlayColor: _color(value).withValues(alpha: 0.12),
              inactiveTrackColor:
                  AppColors.primaryTextColor.withValues(alpha: 0.1),
              trackHeight: 5,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 11),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mild',
                    style: GoogleFonts.dmSans(
                        fontSize: 11.sp,
                        color: AppColors.primaryTextColor
                            .withValues(alpha: 0.4))),
                Text('Severe',
                    style: GoogleFonts.dmSans(
                        fontSize: 11.sp,
                        color: AppColors.primaryTextColor
                            .withValues(alpha: 0.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  final String value;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DurationCard({
    super.key,
    required this.value,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.dailyAssessment.withValues(alpha: 0.13)
              : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected
                ? AppColors.dailyAssessment
                : AppColors.primaryTextColor.withValues(alpha: 0.1),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.dailyAssessment.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: selected
                  ? AppColors.primaryTextColor
                  : AppColors.primaryTextColor.withValues(alpha: 0.35),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: selected
                    ? AppColors.primaryTextColor
                    : AppColors.primaryTextColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 3: Analyzing ─────────────────────────────────────────────

class _AnalyzingStep extends StatelessWidget {
  const _AnalyzingStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedAssessment(
              height: 150.h,
              width: 150.w,
            ),
            SizedBox(height: 8.h),
            Text(
              'Running AI analysis...',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primaryTextColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Matching your pain pattern, area\nand duration to our clinical database',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor.withValues(alpha: 0.45),
                fontSize: 13.sp,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingBrainIcon extends StatefulWidget {
  const _PulsingBrainIcon();

  @override
  State<_PulsingBrainIcon> createState() => _PulsingBrainIconState();
}

class _PulsingBrainIconState extends State<_PulsingBrainIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Icon(Icons.psychology_rounded,
            color: AppColors.dailyAssessment, size: 44.sp),
      ),
    );
  }
}

// ── Step 4: Results ───────────────────────────────────────────────

class _ResultsStep extends StatelessWidget {
  const _ResultsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final result = context.watch<AssessmentProvider>().result;
    if (result == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DiagnosisCard(result: result),
          SizedBox(height: 20.h),

          Text(
            S.recommendedExercises,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),

          ...result.exerciseIds.map((id) {
            final ex = findExerciseById(id);
            if (ex == null) return const SizedBox.shrink();
            return ExerciseCard(
              exercise: ex,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ExerciseDetailScreen(
                    exercise: ex,
                    fromChat: true,
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 16.h),

          // Disclaimer
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppColors.warning, size: 16.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    S.disclaimer,
                    style: GoogleFonts.dmSans(
                      fontSize: 11.sp,
                      color: AppColors.primaryTextColor
                          .withValues(alpha: 0.55),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),
          _PrimaryButton(
            label: S.newAssessment,
            onTap: () => context.read<AssessmentProvider>().reset(),
          ),
        ],
      ),
    );
  }
}

class _DiagnosisCard extends StatelessWidget {
  final dynamic result;
  const _DiagnosisCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: AppColors.dailyAssessment,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.dailyAssessment.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.areaLabel(result.area),
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.6),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  'AI Generated',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            result.diagnosis,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  '${result.confidence}% ${S.confidenceMatch}',
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
