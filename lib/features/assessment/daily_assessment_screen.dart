import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/exercise_data.dart';
import 'package:physioai/data/hive_boxes/hive_service.dart';
import 'package:physioai/data/models/daily_check_in.dart';
import 'package:physioai/data/plan_data.dart';
import 'package:physioai/engine/daily_insight_engine.dart';
import 'package:physioai/features/assessment/assessment_screen.dart';
import 'package:physioai/features/exercises/plan_detail_screen.dart';
import 'package:physioai/features/exercises/plans_browse_view.dart';
import 'package:physioai/providers/assessment_provider.dart';
import 'package:physioai/providers/plan_provider.dart';
import 'package:physioai/widgets/common/ai_logo.dart';
import 'package:provider/provider.dart';

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

// welcome → first-time user with no history
// checkIn → regular flow
// analyzing → AI processing animation
// results → insight + charts
enum _DAPhase { welcome, checkIn, analyzing, results }

class DailyAssessmentScreen extends StatefulWidget {
  const DailyAssessmentScreen({super.key});

  @override
  State<DailyAssessmentScreen> createState() => _DailyAssessmentScreenState();
}

class _DailyAssessmentScreenState extends State<DailyAssessmentScreen> {
  _DAPhase _phase = _DAPhase.checkIn;
  int _checkInStep =
      0; // 0=pain 1=exercise+symptoms 2=wellness 3=empathy(plan only)

  int _painLevel = 5;
  String _exerciseFeel = 'moderate';
  final Set<String> _selectedSymptoms = {'no_change'};
  String _sleepQuality = 'okay';
  String _energyLevel = 'normal';
  String _stressLevel = 'moderate';
  String _moodToday = 'okay';
  String _activityLevel = 'light';

  DailyInsight? _insight;
  List<DailyCheckIn> _history = [];
  DailyCheckIn? _todayEntry;
  bool _alreadyDoneToday = false;
  bool _hasActivePlan = false;

  // Free (standalone) exercises done today
  bool _hasFreeExercisesToday = false;
  List<String> _todayFreeExerciseNames = [];
  String _freeExerciseFeel = 'moderate';

  bool get _hasBoth => _hasActivePlan && _hasFreeExercisesToday;

  @override
  void initState() {
    super.initState();
    _hasActivePlan = context.read<PlanProvider>().hasActivePlan;
    _loadData();
  }

  // Steps: 3 without plan (pain→exercise→wellness), 4 with plan (+empathy)
  int get _totalSteps => _hasActivePlan ? 4 : 3;

  void _loadData() {
    final now = DateTime.now();
    final all = HiveService.checkInsBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    DailyCheckIn? todayEntry;
    for (final c in all) {
      if (c.date.year == now.year &&
          c.date.month == now.month &&
          c.date.day == now.day) {
        todayEntry = c;
        break;
      }
    }

    final cutoff = DateTime(now.year, now.month, now.day - 7);
    final history = all.where((c) {
      final isToday = c.date.year == now.year &&
          c.date.month == now.month &&
          c.date.day == now.day;
      return !isToday && c.date.isAfter(cutoff);
    }).toList();

    // Detect standalone exercise logs from today
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayLogs = HiveService.exerciseLogsBox.values
        .where((log) => log.completedAt.isAfter(todayStart))
        .toList();
    final freeNames = todayLogs
        .map((l) => findExerciseById(l.exerciseId)?.name ?? l.exerciseId)
        .toSet()
        .toList();

    // New user = no check-in history, no exercises, no plan
    final isNewUser = history.isEmpty &&
        todayEntry == null &&
        HiveService.exerciseLogsBox.isEmpty &&
        !_hasActivePlan;

    setState(() {
      _history = history;
      _todayEntry = todayEntry;
      _alreadyDoneToday = todayEntry != null;
      _hasFreeExercisesToday = freeNames.isNotEmpty;
      _todayFreeExerciseNames = freeNames;

      if (todayEntry != null) {
        _phase = _DAPhase.results;
        _buildInsight(
          pain: todayEntry.painLevel,
          feel: todayEntry.exerciseFeel,
          symptoms: todayEntry.symptoms,
          sleep: todayEntry.sleepQuality,
          energy: todayEntry.energyLevel,
          stress: todayEntry.stressLevel,
          mood: todayEntry.moodToday,
          activity: todayEntry.activityLevel,
        );
      } else if (isNewUser) {
        _phase = _DAPhase.welcome;
      } else {
        _phase = _DAPhase.checkIn;
      }
    });
  }

  void _buildInsight({
    required int pain,
    required String feel,
    required List<String> symptoms,
    String? sleep,
    String? energy,
    String? stress,
    String? mood,
    String? activity,
  }) {
    final planProvider = context.read<PlanProvider>();
    _insight = DailyInsightEngine.generate(
      todayPain: pain,
      exerciseFeel: feel,
      symptoms: symptoms,
      recentHistory: _history,
      planName: planProvider.activePlan?.name,
      planDay: planProvider.todayDayNumber,
      planTotalDays: planProvider.activePlan?.durationDays,
      sleepQuality: sleep,
      energyLevel: energy,
      stressLevel: stress,
      moodToday: mood,
      activityLevel: activity,
    );
  }

  Future<void> _submitCheckIn() async {
    _buildInsight(
      pain: _painLevel,
      feel: _exerciseFeel,
      symptoms: _selectedSymptoms.toList(),
      sleep: _hasActivePlan ? _sleepQuality : null,
      energy: _hasActivePlan ? _energyLevel : null,
      stress: _stressLevel,
      mood: _moodToday,
      activity: _activityLevel,
    );

    setState(() => _phase = _DAPhase.analyzing);
    await Future.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;

    final insight = _insight!;
    final fullInsight = insight.planNote != null
        ? '${insight.message}\n\n${insight.planNote}'
        : insight.message;

    final entry = DailyCheckIn(
      date: DateTime.now(),
      painLevel: _painLevel,
      exerciseFeel: _exerciseFeel,
      symptoms: _selectedSymptoms.toList(),
      aiInsight: fullInsight,
      sleepQuality: _hasActivePlan ? _sleepQuality : '',
      energyLevel: _hasActivePlan ? _energyLevel : '',
      stressLevel: _stressLevel,
      moodToday: _moodToday,
      activityLevel: _activityLevel,
    );
    await HiveService.checkInsBox.add(entry);

    setState(() {
      _todayEntry = entry;
      _alreadyDoneToday = true;
      _phase = _DAPhase.results;
    });
  }

  void _advanceStep() {
    if (_checkInStep == 0) {
      setState(() => _checkInStep = 1);
    } else if (_checkInStep == 1) {
      setState(() => _checkInStep = 2); // → wellness (all users)
    } else if (_checkInStep == 2 && _hasActivePlan) {
      setState(() => _checkInStep = 3); // → empathy (plan users)
    } else {
      _submitCheckIn();
    }
  }

  DailyCheckIn? get _yesterdayEntry {
    final now = DateTime.now();
    final y = DateTime(now.year, now.month, now.day - 1);
    for (final c in _history) {
      if (c.date.year == y.year &&
          c.date.month == y.month &&
          c.date.day == y.day) {
        return c;
      }
    }
    return null;
  }

  List<DailyCheckIn> get _chartData {
    final all = <DailyCheckIn>[..._history];
    if (_todayEntry != null) all.add(_todayEntry!);
    all.sort((a, b) => a.date.compareTo(b.date));
    return all.take(7).toList();
  }

  double get _sevenDayAvg {
    final data = _chartData;
    if (data.isEmpty) return 0;
    return data.map((c) => c.painLevel).reduce((a, b) => a + b) / data.length;
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _kGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
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
          Expanded(
            child: Text(
              'Daily Assessment',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primaryTextColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.dailyAssessment.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Text(
              _todayLabel(),
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

  String _todayLabel() {
    final now = DateTime.now();
    const m = [
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
    return '${now.day} ${m[now.month - 1]}';
  }

  Widget _buildBody() {
    return switch (_phase) {
      _DAPhase.welcome => _buildWelcome(),
      _DAPhase.checkIn => _buildCheckIn(),
      _DAPhase.analyzing => _buildAnalyzing(),
      _DAPhase.results => _buildResults(),
    };
  }

  // ── Welcome (new user) ───────────────────────────────────────

  Widget _buildWelcome() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: Column(
        children: [
          SizedBox(height: 24.h),

          // Purple hero circle
          AnimatedAssessment(
            height: 150.h,
            width: 150.w,
          ),
          SizedBox(height: 8.h),

          Text(
            'Welcome to\nDaily Assessment',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Track your pain every day, answer a few\nquick questions, and get AI-powered\nrecovery insights tailored to you.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.5),
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
          SizedBox(height: 36.h),

          // What we ask — 3 chips
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              _WelcomeChip(Icons.thermostat_rounded, 'Pain level'),
              _WelcomeChip(Icons.fitness_center_rounded, 'Exercise feel'),
              _WelcomeChip(Icons.sentiment_satisfied_rounded, 'Mood & stress'),
              _WelcomeChip(Icons.directions_walk_rounded, 'Activity'),
              _WelcomeChip(Icons.auto_awesome_rounded, 'Symptoms'),
            ],
          ),
          SizedBox(height: 44.h),

          // Primary: AI Diagnosis
          GestureDetector(
            onTap: () {
              context.read<AssessmentProvider>().reset();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AssessmentScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.dailyAssessment,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dailyAssessment.withValues(alpha: 0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Run full AI diagnosis first',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),

          // Secondary: Quick check-in
          GestureDetector(
            onTap: () => setState(() => _phase = _DAPhase.checkIn),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.18),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Skip to quick check-in',
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'You can always run the AI diagnosis from the results page too.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.3),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ── Check-in ────────────────────────────────────────────────

  Widget _buildCheckIn() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
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
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      ),
      child: switch (_checkInStep) {
        0 => _PainStep(
            key: const ValueKey(0),
            totalSteps: _totalSteps,
            painLevel: _painLevel,
            yesterdayPain: _yesterdayEntry?.painLevel,
            onChanged: (v) => setState(() => _painLevel = v),
            onContinue: _advanceStep,
          ),
        1 => _ExerciseSymptomStep(
            key: const ValueKey(1),
            totalSteps: _totalSteps,
            exerciseFeel: _exerciseFeel,
            selectedSymptoms: _selectedSymptoms,
            hasActivePlan: _hasActivePlan,
            hasBoth: _hasBoth,
            planName: context.read<PlanProvider>().activePlan?.name,
            freeExerciseNames: _todayFreeExerciseNames,
            freeExerciseFeel: _freeExerciseFeel,
            onFeelChanged: (v) => setState(() => _exerciseFeel = v),
            onFreeFeelChanged: (v) => setState(() => _freeExerciseFeel = v),
            onSymptomToggled: _toggleSymptom,
            onContinue: _advanceStep,
          ),
        2 => _WellnessStep(
            key: const ValueKey(2),
            totalSteps: _totalSteps,
            stressLevel: _stressLevel,
            moodToday: _moodToday,
            activityLevel: _activityLevel,
            onStressChanged: (v) => setState(() => _stressLevel = v),
            onMoodChanged: (v) => setState(() => _moodToday = v),
            onActivityChanged: (v) => setState(() => _activityLevel = v),
            onContinue: _advanceStep,
            hasActivePlan: _hasActivePlan,
          ),
        _ => _EmpathyStep(
            key: const ValueKey(3),
            totalSteps: _totalSteps,
            sleepQuality: _sleepQuality,
            energyLevel: _energyLevel,
            onSleepChanged: (v) => setState(() => _sleepQuality = v),
            onEnergyChanged: (v) => setState(() => _energyLevel = v),
            onSubmit: _advanceStep,
          ),
      },
    );
  }

  void _toggleSymptom(String s) {
    setState(() {
      if (s == 'no_change') {
        _selectedSymptoms
          ..clear()
          ..add('no_change');
      } else {
        _selectedSymptoms.remove('no_change');
        if (_selectedSymptoms.contains(s)) {
          _selectedSymptoms.remove(s);
          if (_selectedSymptoms.isEmpty) _selectedSymptoms.add('no_change');
        } else {
          _selectedSymptoms.add(s);
        }
      }
    });
  }

  // ── Analyzing ───────────────────────────────────────────────

  Widget _buildAnalyzing() {
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
            SizedBox(height: 30.h),
            Text(
              'Analysing your recovery...',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primaryTextColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Comparing pain trends, mood, stress\nand your wellbeing today',
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

  // ── Results ─────────────────────────────────────────────────

  Widget _buildResults() {
    final insight = _insight;
    if (insight == null) return const SizedBox.shrink();

    final todayPain = _todayEntry?.painLevel ?? _painLevel;
    final planProvider = context.watch<PlanProvider>();
    final chart = _chartData;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_alreadyDoneToday) ...[
            _AlreadyDoneBanner(),
            SizedBox(height: 10.h),
          ],
          _MomentumCard(insight: insight, todayPain: todayPain),
          SizedBox(height: 14.h),
          _StatsRow(
            todayPain: todayPain,
            avgPain: _sevenDayAvg,
            streak: insight.streakDays,
          ),
          SizedBox(height: 16.h),
          if (chart.isNotEmpty) ...[
            Text(
              '7-Day Pain Trend',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primaryTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            _PainTrendChart(data: chart),
            SizedBox(height: 16.h),
          ],
          if (insight.planNote != null) ...[
            _PlanNoteCard(note: insight.planNote!),
            SizedBox(height: 14.h),
          ],
          if (!planProvider.hasActivePlan && insight.suggestPlan) ...[
            _SuggestPlanCard(
              onBrowse: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PlansBrowseView(standalone: true)),
              ),
            ),
            SizedBox(height: 10.h),
          ],
          if (planProvider.hasActivePlan) ...[
            _ActionButton(
              icon: Icons.calendar_today_rounded,
              label: 'View my recovery plan',
              color: planCardColor(planProvider.activeEnrollment!.planId),
              onTap: () {
                final plan = planProvider.activePlan!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlanDetailScreen(
                      plan: plan,
                      color: planCardColor(plan.id),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10.h),
          ],
          if (!planProvider.hasActivePlan && !insight.suggestPlan) ...[
            _ActionButton(
              icon: Icons.list_alt_rounded,
              label: 'Browse recovery plans',
              color: AppColors.dailyAssessment,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PlansBrowseView(standalone: true)),
              ),
            ),
            SizedBox(height: 10.h),
          ],
          _ActionButton(
            icon: Icons.psychology_rounded,
            label: 'Run full AI diagnosis',
            color: AppColors.accent,
            onTap: () {
              context.read<AssessmentProvider>().reset();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AssessmentScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Welcome chip ──────────────────────────────────────────────────

class _WelcomeChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WelcomeChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.dailyAssessment.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
            color: AppColors.dailyAssessment.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 13.sp,
              color: AppColors.primaryTextColor.withValues(alpha: 0.7)),
          SizedBox(width: 5.w),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 0: Pain Level ────────────────────────────────────────────

class _PainStep extends StatelessWidget {
  final int totalSteps;
  final int painLevel;
  final int? yesterdayPain;
  final void Function(int) onChanged;
  final VoidCallback onContinue;

  const _PainStep({
    super.key,
    required this.totalSteps,
    required this.painLevel,
    required this.yesterdayPain,
    required this.onChanged,
    required this.onContinue,
  });

  Color _painColor(int v) {
    if (v <= 3) return AppColors.success;
    if (v <= 6) return AppColors.warning;
    return AppColors.error;
  }

  String _painLabel(int v) {
    if (v <= 2) return 'Very mild';
    if (v <= 4) return 'Mild';
    if (v <= 6) return 'Moderate';
    if (v <= 8) return 'Severe';
    return 'Very severe';
  }

  @override
  Widget build(BuildContext context) {
    final int? yPain = yesterdayPain;
    final diff = yPain != null ? painLevel - yPain : null;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepIndicator(current: 1, total: totalSteps),
          SizedBox(height: 28.h),
          Text(
            'How is your\npain today?',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          if (yPain != null)
            Row(
              children: [
                Text(
                  'Yesterday: $yPain/10',
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.45),
                    fontSize: 12.sp,
                  ),
                ),
                if (diff != null && diff != 0) ...[
                  SizedBox(width: 6.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: (diff < 0 ? AppColors.success : AppColors.error)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${diff > 0 ? '+' : ''}$diff today',
                      style: GoogleFonts.dmSans(
                        color: diff < 0 ? AppColors.success : AppColors.error,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            Text(
              'Rate your current pain level',
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor.withValues(alpha: 0.45),
                fontSize: 13.sp,
              ),
            ),
          SizedBox(height: 36.h),
          Center(
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _painColor(painLevel).withValues(alpha: 0.1),
                border: Border.all(
                  color: _painColor(painLevel).withValues(alpha: 0.4),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _painColor(painLevel).withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$painLevel',
                    style: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w800,
                      color: _painColor(painLevel),
                    ),
                  ),
                  Text(
                    '/ 10',
                    style: GoogleFonts.dmSans(
                      fontSize: 12.sp,
                      color: _painColor(painLevel).withValues(alpha: 0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              _painLabel(painLevel),
              style: GoogleFonts.dmSans(
                fontSize: 13.sp,
                color: _painColor(painLevel),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _painColor(painLevel),
              thumbColor: _painColor(painLevel),
              overlayColor: _painColor(painLevel).withValues(alpha: 0.12),
              inactiveTrackColor:
                  AppColors.primaryTextColor.withValues(alpha: 0.1),
              trackHeight: 5,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
            ),
            child: Slider(
              value: painLevel.toDouble(),
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
                        color:
                            AppColors.primaryTextColor.withValues(alpha: 0.4))),
                Text('Severe',
                    style: GoogleFonts.dmSans(
                        fontSize: 11.sp,
                        color:
                            AppColors.primaryTextColor.withValues(alpha: 0.4))),
              ],
            ),
          ),
          const Spacer(),
          _PrimaryButton(label: 'Continue', onTap: onContinue),
        ],
      ),
    );
  }
}

// ── Step 1: Exercise Feel + Symptoms ──────────────────────────────

class _ExerciseSymptomStep extends StatelessWidget {
  final int totalSteps;
  final String exerciseFeel;
  final Set<String> selectedSymptoms;
  final bool hasActivePlan;
  final bool hasBoth;
  final String? planName;
  final List<String> freeExerciseNames;
  final String freeExerciseFeel;
  final void Function(String) onFeelChanged;
  final void Function(String) onFreeFeelChanged;
  final void Function(String) onSymptomToggled;
  final VoidCallback onContinue;

  const _ExerciseSymptomStep({
    super.key,
    required this.totalSteps,
    required this.exerciseFeel,
    required this.selectedSymptoms,
    required this.hasActivePlan,
    this.hasBoth = false,
    this.planName,
    this.freeExerciseNames = const [],
    this.freeExerciseFeel = 'moderate',
    required this.onFeelChanged,
    required this.onFreeFeelChanged,
    required this.onSymptomToggled,
    required this.onContinue,
  });

  static const _feelOptions = [
    ('easy', 'Easy', Icons.sentiment_very_satisfied_rounded, AppColors.success),
    (
      'moderate',
      'Moderate',
      Icons.sentiment_satisfied_rounded,
      AppColors.warning
    ),
    ('hard', 'Hard', Icons.sentiment_dissatisfied_rounded, Color(0xFFEF8C34)),
    ('skipped', 'Skipped', Icons.close_rounded, AppColors.error),
  ];

  static const _symptomOptions = [
    ('no_change', 'No changes'),
    ('less_pain', 'Less pain'),
    ('more_stiff', 'More stiffness'),
    ('swelling', 'New swelling'),
    ('tingling', 'Tingling'),
    ('worse', 'Overall worse'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepIndicator(current: 2, total: totalSteps),
          SizedBox(height: 16.h),
          Text(
            hasBoth
                ? "Rate today's\nexercises"
                : "How did today's\nexercises feel?",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            hasBoth
                ? 'You did both plan and free exercises today'
                : hasActivePlan
                    ? 'Based on your recovery plan exercises today'
                    : 'Select based on any movement or exercise you did',
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.45),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 18.h),
          if (hasBoth) ...[
            _ExerciseContextCard(
              icon: Icons.calendar_month_rounded,
              title: planName ?? 'Recovery Plan',
              subtitle: 'Your active plan exercises',
              accentColor: AppColors.dailyAssessment,
              feel: exerciseFeel,
              feelOptions: _feelOptions,
              onFeelChanged: onFeelChanged,
            ),
            SizedBox(height: 14.h),
            _ExerciseContextCard(
              icon: Icons.fitness_center_rounded,
              title: 'Free Exercises',
              subtitle: freeExerciseNames.take(3).join(', '),
              accentColor: AppColors.accent,
              feel: freeExerciseFeel,
              feelOptions: _feelOptions,
              onFeelChanged: onFreeFeelChanged,
              exerciseNames: freeExerciseNames,
            ),
          ] else
            Row(
              children: _feelOptions.map((opt) {
                final selected = exerciseFeel == opt.$1;
                final isLast = opt.$1 == 'skipped';
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onFeelChanged(opt.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: EdgeInsets.only(right: isLast ? 0 : 8.w),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: selected
                            ? opt.$4.withValues(alpha: 0.13)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: selected
                              ? opt.$4
                              : AppColors.primaryTextColor
                                  .withValues(alpha: 0.1),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(opt.$3,
                              color: selected
                                  ? opt.$4
                                  : AppColors.primaryTextColor
                                      .withValues(alpha: 0.3),
                              size: 22.sp),
                          SizedBox(height: 5.h),
                          Text(
                            opt.$2,
                            style: GoogleFonts.dmSans(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? opt.$4
                                  : AppColors.primaryTextColor
                                      .withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 28.h),
          Text(
            'Any changes since yesterday?',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _symptomOptions.map((opt) {
              final selected = selectedSymptoms.contains(opt.$1);
              return GestureDetector(
                onTap: () => onSymptomToggled(opt.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.dailyAssessment.withValues(alpha: 0.18)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: selected
                          ? AppColors.dailyAssessment
                          : AppColors.primaryTextColor.withValues(alpha: 0.12),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    opt.$2,
                    style: GoogleFonts.dmSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primaryTextColor
                          : AppColors.primaryTextColor.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 36.h),
          _PrimaryButton(label: 'Continue', onTap: onContinue),
        ],
      ),
    );
  }
}

// ── Exercise Context Card (dual-mode) ────────────────────────────

class _ExerciseContextCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String feel;
  final List<(String, String, IconData, Color)> feelOptions;
  final void Function(String) onFeelChanged;
  final List<String> exerciseNames;

  const _ExerciseContextCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.feel,
    required this.feelOptions,
    required this.onFeelChanged,
    this.exerciseNames = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.h,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Icon(icon, color: accentColor, size: 17.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: GoogleFonts.dmSans(
                          color:
                              AppColors.primaryTextColor.withValues(alpha: 0.45),
                          fontSize: 10.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (exerciseNames.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 4.h,
              children: exerciseNames.take(4).map((name) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    name,
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            children: feelOptions.map((opt) {
              final selected = feel == opt.$1;
              final isLast = opt.$1 == 'skipped';
              return Expanded(
                child: GestureDetector(
                  onTap: () => onFeelChanged(opt.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.only(right: isLast ? 0 : 8.w),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: selected
                          ? opt.$4.withValues(alpha: 0.13)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: selected
                            ? opt.$4
                            : AppColors.primaryTextColor.withValues(alpha: 0.1),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(opt.$3,
                            color: selected
                                ? opt.$4
                                : AppColors.primaryTextColor
                                    .withValues(alpha: 0.3),
                            size: 20.sp),
                        SizedBox(height: 3.h),
                        Text(
                          opt.$2,
                          style: GoogleFonts.dmSans(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? opt.$4
                                : AppColors.primaryTextColor
                                    .withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Step 2: Wellness (mood, stress, activity — ALL users) ─────────

class _WellnessStep extends StatelessWidget {
  final int totalSteps;
  final String stressLevel;
  final String moodToday;
  final String activityLevel;
  final bool hasActivePlan;
  final void Function(String) onStressChanged;
  final void Function(String) onMoodChanged;
  final void Function(String) onActivityChanged;
  final VoidCallback onContinue;

  const _WellnessStep({
    super.key,
    required this.totalSteps,
    required this.stressLevel,
    required this.moodToday,
    required this.activityLevel,
    required this.hasActivePlan,
    required this.onStressChanged,
    required this.onMoodChanged,
    required this.onActivityChanged,
    required this.onContinue,
  });

  static const _stressOptions = [
    ('calm', 'Calm', Icons.self_improvement_rounded, AppColors.success),
    ('moderate', 'Moderate', Icons.remove_rounded, AppColors.warning),
    ('stressed', 'Stressed', Icons.storm_rounded, AppColors.error),
  ];

  static const _moodOptions = [
    ('good', 'Good', Icons.sentiment_very_satisfied_rounded, AppColors.success),
    ('okay', 'Okay', Icons.sentiment_neutral_rounded, AppColors.warning),
    ('low', 'Low', Icons.sentiment_dissatisfied_rounded, AppColors.info),
  ];

  static const _activityOptions = [
    (
      'resting',
      'Resting',
      Icons.airline_seat_recline_extra_rounded,
      AppColors.info
    ),
    ('light', 'Light', Icons.directions_walk_rounded, AppColors.warning),
    ('active', 'Active', Icons.directions_run_rounded, AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepIndicator(current: 3, total: totalSteps),
          SizedBox(height: 16.h),
          Text(
            'How are you\nfeeling overall?',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'These signals help personalise your AI insight',
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.45),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 28.h),
          _TripleChoice(
            question: 'Stress level today?',
            options: _stressOptions,
            selected: stressLevel,
            onChanged: onStressChanged,
          ),
          SizedBox(height: 24.h),
          _TripleChoice(
            question: "How's your mood?",
            options: _moodOptions,
            selected: moodToday,
            onChanged: onMoodChanged,
          ),
          SizedBox(height: 24.h),
          _TripleChoice(
            question: 'Activity level today?',
            options: _activityOptions,
            selected: activityLevel,
            onChanged: onActivityChanged,
          ),
          SizedBox(height: 36.h),
          _PrimaryButton(
            label: hasActivePlan ? 'Continue' : 'See my recovery insight',
            onTap: onContinue,
          ),
        ],
      ),
    );
  }
}

class _TripleChoice extends StatelessWidget {
  final String question;
  final List<(String, String, IconData, Color)> options;
  final String selected;
  final void Function(String) onChanged;

  const _TripleChoice({
    required this.question,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.primaryTextColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: options.map((opt) {
            final isSelected = selected == opt.$1;
            final isLast = opt == options.last;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(opt.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: isLast ? 0 : 10.w),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? opt.$4.withValues(alpha: 0.13)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? opt.$4
                          : AppColors.primaryTextColor.withValues(alpha: 0.1),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: opt.$4.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Icon(opt.$3,
                          color: isSelected
                              ? opt.$4
                              : AppColors.primaryTextColor
                                  .withValues(alpha: 0.3),
                          size: 22.sp),
                      SizedBox(height: 5.h),
                      Text(
                        opt.$2,
                        style: GoogleFonts.dmSans(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? opt.$4
                              : AppColors.primaryTextColor
                                  .withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Step 3: Empathy (plan users only) ────────────────────────────

class _EmpathyStep extends StatelessWidget {
  final int totalSteps;
  final String sleepQuality;
  final String energyLevel;
  final void Function(String) onSleepChanged;
  final void Function(String) onEnergyChanged;
  final VoidCallback onSubmit;

  const _EmpathyStep({
    super.key,
    required this.totalSteps,
    required this.sleepQuality,
    required this.energyLevel,
    required this.onSleepChanged,
    required this.onEnergyChanged,
    required this.onSubmit,
  });

  static const _sleepOptions = [
    ('poorly', 'Poorly', Icons.bedtime_off_rounded, AppColors.error),
    ('okay', 'Okay', Icons.bedtime_rounded, AppColors.warning),
    ('well', 'Well', Icons.star_rounded, AppColors.success),
  ];

  static const _energyOptions = [
    ('low', 'Low', Icons.battery_1_bar_rounded, AppColors.error),
    ('normal', 'Normal', Icons.battery_4_bar_rounded, AppColors.warning),
    ('good', 'Good', Icons.bolt_rounded, AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepIndicator(current: 4, total: totalSteps),
          SizedBox(height: 16.h),
          Text(
            'Last few things\nfor today',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryTextColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Sleep and energy affect your plan performance',
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.45),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 32.h),
          _TripleChoice(
            question: 'How did you sleep last night?',
            options: _sleepOptions,
            selected: sleepQuality,
            onChanged: onSleepChanged,
          ),
          SizedBox(height: 28.h),
          _TripleChoice(
            question: "How's your energy today?",
            options: _energyOptions,
            selected: energyLevel,
            onChanged: onEnergyChanged,
          ),
          SizedBox(height: 36.h),
          _PrimaryButton(label: 'See my recovery insight', onTap: onSubmit),
        ],
      ),
    );
  }
}

// ── Results Widgets ───────────────────────────────────────────────

class _AlreadyDoneBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 16.sp),
          SizedBox(width: 8.w),
          Text(
            "Today's check-in complete",
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.6),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MomentumCard extends StatelessWidget {
  final DailyInsight insight;
  final int todayPain;

  const _MomentumCard({required this.insight, required this.todayPain});

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (insight.momentum) {
      'improving' => (
          Icons.trending_up_rounded,
          'Improving',
          AppColors.success
        ),
      'declining' => (
          Icons.trending_down_rounded,
          'Needs attention',
          AppColors.warning
        ),
      _ => (Icons.trending_flat_rounded, 'Stable', AppColors.info),
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(9.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recovery Momentum',
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor.withValues(alpha: 0.4),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      color: color,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: AppColors.dailyAssessment.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  '$todayPain / 10',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            insight.message,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.72),
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int todayPain;
  final double avgPain;
  final int streak;

  const _StatsRow({
    required this.todayPain,
    required this.avgPain,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'Today',
            value: '$todayPain',
            unit: '/ 10',
            color: AppColors.primaryTextColor,
            bgColor: AppColors.dailyAssessment,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatBox(
            label: '7-day avg',
            value: avgPain.toStringAsFixed(1),
            unit: '/ 10',
            color: AppColors.primaryTextColor,
            bgColor: AppColors.recentSessionCard,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatBox(
            label: 'Streak',
            value: '$streak',
            unit: streak == 1 ? 'day' : 'days',
            color: AppColors.primaryTextColor,
            bgColor: AppColors.inProgressCard,
            icon: Icons.local_fire_department_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final Color bgColor;
  final IconData? icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.bgColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.55),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (icon != null)
            Icon(icon, color: color.withValues(alpha: 0.65), size: 16.sp)
          else
            Container(
              width: 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: color.withValues(alpha: 0.45)),
            ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.dmSans(
              fontSize: 10.sp,
              color: color.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10.sp,
              color: color.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PainTrendChart extends StatelessWidget {
  final List<DailyCheckIn> data;

  const _PainTrendChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.painLevel.toDouble());
    }).toList();

    return Container(
      height: 170.h,
      padding: EdgeInsets.fromLTRB(4.w, 16.h, 16.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 11,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.chartGrid.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: 5,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}',
                  style: GoogleFonts.dmSans(
                    fontSize: 10.sp,
                    color: AppColors.primaryTextColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= data.length) return const Text('');
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];
                  final label = days[(data[i].date.weekday - 1).clamp(0, 6)];
                  final isToday = i == data.length - 1;
                  return Text(
                    label,
                    style: GoogleFonts.dmSans(
                      fontSize: 10.sp,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
                      color: isToday
                          ? AppColors.dailyAssessment
                          : AppColors.primaryTextColor.withValues(alpha: 0.3),
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
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.primaryTextColor,
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                        'Pain ${s.y.toInt()}/10',
                        GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppColors.dailyAssessment,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, _, __, index) {
                  final isToday = index == data.length - 1;
                  return FlDotCirclePainter(
                    radius: isToday ? 6.5 : 4,
                    color: AppColors.dailyAssessment,
                    strokeWidth: 2.5,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.dailyAssessment.withValues(alpha: 0.2),
                    AppColors.dailyAssessment.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanNoteCard extends StatelessWidget {
  final String note;

  const _PlanNoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppColors.dailyAssessment.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
            color: AppColors.dailyAssessment.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month_rounded,
              color: AppColors.dailyAssessment, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              note,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestPlanCard extends StatelessWidget {
  final VoidCallback onBrowse;

  const _SuggestPlanCard({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border:
            Border.all(color: AppColors.dailyAssessment.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.dailyAssessment.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(9.w),
                decoration: BoxDecoration(
                  color: AppColors.dailyAssessment.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(Icons.auto_awesome_rounded,
                    color: AppColors.dailyAssessment, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start a recovery plan',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Guided daily exercises for faster healing',
                      style: GoogleFonts.dmSans(
                        color:
                            AppColors.primaryTextColor.withValues(alpha: 0.45),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: onBrowse,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 13.h),
              decoration: BoxDecoration(
                color: AppColors.dailyAssessment,
                borderRadius: BorderRadius.circular(20.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Browse recovery plans',
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 18.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 12.sp,
                color: AppColors.primaryTextColor.withValues(alpha: 0.35)),
          ],
        ),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────

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
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.dailyAssessment),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.dailyAssessment,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.dailyAssessment.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            color: AppColors.primaryTextColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon();

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.55, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
            color: AppColors.dailyAssessment, size: 38.sp),
      ),
    );
  }
}
