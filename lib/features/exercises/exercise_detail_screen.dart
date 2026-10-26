import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/models/exercise.dart';
import 'package:physioai/providers/exercise_provider.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  final Color? color;

  /// When true the exercise was opened from the AI chat.
  /// Prevents the exercise from being registered as "in progress" so it
  /// does not appear on the home social card.
  final bool fromChat;

  /// When true the exercise was opened from inside a plan.
  /// Like [fromChat], skips touching the home card's in-progress state so
  /// completing plan exercises doesn't remove or replace any active exercise
  /// the user had running independently.
  final bool fromPlan;
  final String imageUrl;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    this.color,
    this.fromChat = false,
    this.fromPlan = false,
    this.imageUrl = '',
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  bool _markedDone = false;
  bool _sessionStarted = false;
  final Set<int> _checkedSteps = {};

  Exercise get ex => widget.exercise;
  int get _totalSteps => ex.instructions.length;
  double get _progress =>
      _totalSteps == 0 ? 0 : _checkedSteps.length / _totalSteps;
  bool get _allStepsDone =>
      _sessionStarted && _checkedSteps.length == _totalSteps;

  static Color _areaColor(List<String> bodyAreas) {
    const map = <String, Color>{
      'neck': AppColors.recentSessionCard,
      'shoulders': AppColors.aiSugesstionCard,
      'upper_back': AppColors.dailyAssessment,
      'lower_back': AppColors.socialCard,
      'hips': AppColors.recentSessionCard,
      'knees': AppColors.aiSugesstionCard,
      'ankles': AppColors.dailyAssessment,
    };
    return map[bodyAreas.first] ?? AppColors.socialCard;
  }

  @override
  void initState() {
    super.initState();
    if (widget.fromChat) {
      // AI-recommended exercises always start fresh — ignore prior completion
      // state so the user can redo them freely without the "done" lock.
      return;
    }
    final provider = context.read<ExerciseProvider>();
    _markedDone = provider.isDoneToday(ex.id);
    // Only restore home-card in-progress state for standalone exercises,
    // not for exercises opened from within a plan.
    if (!widget.fromPlan && provider.inProgressExercise?.id == ex.id) {
      _sessionStarted = true;
      _checkedSteps.addAll(provider.inProgressCheckedSteps);
    }
  }

  void _toggleStep(int index) {
    if (!_sessionStarted) return;
    setState(() {
      if (_checkedSteps.contains(index)) {
        _checkedSteps.remove(index);
      } else {
        _checkedSteps.add(index);
      }
    });
    // Persist updated step state immediately
    context.read<ExerciseProvider>().saveInProgressSteps(_checkedSteps);
  }

  Future<void> _completeExercise() async {
    await context.read<ExerciseProvider>().markDone(ex.id, ex.sets);
    if (!mounted) return;
    // Don't touch the home card's in-progress state for plan exercises —
    // the user may have an unrelated exercise active there.
    if (!widget.fromPlan) {
      context.read<ExerciseProvider>().setInProgress(null);
    }
    setState(() => _markedDone = true);
    _showCelebrationSheet();
  }

  void _showCelebrationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _CelebrationSheet(
        exercise: ex,
        onDone: () {
          Navigator.of(context).pop(); // close sheet
          Navigator.of(context).pop(); // back to category
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.color ?? _areaColor(ex.bodyAreas);

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
              _TopBar(name: ex.name),
              const Divider(color: AppColors.divider, height: 1, thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCard(exercise: ex, color: cardColor, imageUrl: widget.imageUrl),
                      if (_sessionStarted) ...[
                        _ProgressSection(
                          checked: _checkedSteps.length,
                          total: _totalSteps,
                          progress: _progress,
                        ),
                        _StepsSection(
                          instructions: ex.instructions,
                          checkedSteps: _checkedSteps,
                          onToggle: _toggleStep,
                          enabled: !_markedDone,
                        ),
                      ] else
                        _PreStartHint(totalSteps: _totalSteps),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
              _BottomBar(
                markedDone: _markedDone,
                sessionStarted: _sessionStarted,
                allStepsDone: _allStepsDone,
                onStart: () {
                  setState(() => _sessionStarted = true);
                  if (!widget.fromChat && !widget.fromPlan) {
                    context.read<ExerciseProvider>().setInProgressFull(ex, widget.imageUrl);
                  }
                },
                onComplete: _completeExercise,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String name;
  const _TopBar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Row(
        children: [
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
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
                name,
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero Card ─────────────────────────────────────────────────────

class _HeroCard extends StatefulWidget {
  final Exercise exercise;
  final Color color;
  final String imageUrl;
  const _HeroCard({required this.exercise, required this.color, this.imageUrl = ''});

  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _breathe;

  static const _icons = <String, IconData>{
    'neck': Icons.accessibility_new_rounded,
    'shoulders': Icons.accessibility_rounded,
    'upper_back': Icons.airline_seat_recline_extra_rounded,
    'lower_back': Icons.self_improvement_rounded,
    'hips': Icons.directions_walk_rounded,
    'knees': Icons.directions_run_rounded,
    'ankles': Icons.sports_gymnastics_rounded,
  };

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _breathe = Tween<double>(begin: 0.88, end: 1.08)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final icon = _icons[ex.bodyAreas.first] ?? Icons.fitness_center_rounded;
    final diffColor = switch (ex.difficulty) {
      'beginner' => AppColors.beginnerBadge,
      'intermediate' => AppColors.intermediateBadge,
      _ => AppColors.advancedBadge,
    };

    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (widget.imageUrl.isEmpty)
            Positioned(
              top: -16,
              right: -16,
              child: ScaleTransition(
                scale: _breathe,
                child: Icon(
                  icon,
                  size: 140.sp,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Tag(ex.targetArea),
                    SizedBox(width: 8.w),
                    _Tag(ex.difficultyLabel, textColor: diffColor),
                  ],
                ),
                if (widget.imageUrl.isNotEmpty) ...[
                  SizedBox(height: 14.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      height: 160.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 160.h,
                        color: Colors.white.withValues(alpha: 0.2),
                        child: Center(
                          child: Icon(icon,
                              size: 48.sp,
                              color: Colors.white.withValues(alpha: 0.4)),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 160.h,
                        color: Colors.white.withValues(alpha: 0.2),
                        child: Center(
                          child: Icon(icon,
                              size: 48.sp,
                              color: Colors.white.withValues(alpha: 0.4)),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(height: 18.h),
                  SizedBox(height: 14.h),
                ],
                Text(
                  ex.name,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.timer_outlined,
                      value: ex.durationLabel,
                      label: 'Duration',
                    ),
                    SizedBox(width: 8.w),
                    _StatChip(
                      icon: Icons.repeat_rounded,
                      value: '${ex.sets} sets',
                      label: 'Sets',
                    ),
                    SizedBox(width: 8.w),
                    _StatChip(
                      icon: Icons.sports_gymnastics_rounded,
                      value: ex.repsOrHold,
                      label: 'Reps',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color? textColor;
  const _Tag(this.label, {this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          color: textColor ?? AppColors.primaryTextColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatChip(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 16.sp,
                color: AppColors.primaryTextColor.withValues(alpha: 0.65)),
            SizedBox(height: 4.h),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primaryTextColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor.withValues(alpha: 0.45),
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pre-start Hint ────────────────────────────────────────────────

class _PreStartHint extends StatelessWidget {
  final int totalSteps;
  const _PreStartHint({required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.dailyAssessment.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(Icons.list_alt_rounded,
                  size: 22.sp, color: AppColors.primaryTextColor),
            ),
            SizedBox(width: 14.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalSteps step guide ready',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Tap "Start Exercise" to begin',
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Progress Section ──────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  final int checked;
  final int total;
  final double progress;
  const _ProgressSection(
      {required this.checked, required this.total, required this.progress});

  @override
  Widget build(BuildContext context) {
    final isDone = checked == total;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How To Do It',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.divider,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isDone ? 'All done!' : '$checked / $total steps',
                  style: GoogleFonts.dmSans(
                    color: isDone
                        ? AppColors.success
                        : AppColors.primaryTextColor.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(
                  value >= 1.0
                      ? AppColors.success
                      : AppColors.primaryTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Steps Section ─────────────────────────────────────────────────

class _StepsSection extends StatelessWidget {
  final List<String> instructions;
  final Set<int> checkedSteps;
  final void Function(int) onToggle;
  final bool enabled;

  const _StepsSection({
    required this.instructions,
    required this.checkedSteps,
    required this.onToggle,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Column(
        children: List.generate(
          instructions.length,
          (i) => _StepCard(
            step: i + 1,
            text: instructions[i],
            isChecked: checkedSteps.contains(i),
            enabled: enabled,
            onTap: () => onToggle(i),
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int step;
  final String text;
  final bool isChecked;
  final bool enabled;
  final VoidCallback onTap;

  const _StepCard({
    required this.step,
    required this.text,
    required this.isChecked,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: isChecked
              ? AppColors.success.withValues(alpha: 0.07)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isChecked
                ? AppColors.success.withValues(alpha: 0.35)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isChecked
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: isChecked
                    ? AppColors.success
                    : AppColors.primaryTextColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isChecked
                  ? Icon(Icons.check_rounded,
                      color: Colors.white, size: 16.sp)
                  : Text(
                      '$step',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(
                  text,
                  style: GoogleFonts.dmSans(
                    color: isChecked
                        ? AppColors.primaryTextColor.withValues(alpha: 0.4)
                        : AppColors.primaryTextColor,
                    fontSize: 14.sp,
                    height: 1.5,
                    decoration:
                        isChecked ? TextDecoration.lineThrough : null,
                    decorationColor:
                        AppColors.primaryTextColor.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Action Bar ─────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final bool markedDone;
  final bool sessionStarted;
  final bool allStepsDone;
  final VoidCallback onStart;
  final VoidCallback onComplete;

  const _BottomBar({
    required this.markedDone,
    required this.sessionStarted,
    required this.allStepsDone,
    required this.onStart,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final Color btnColor;
    final String btnLabel;
    final IconData btnIcon;
    final VoidCallback? btnAction;
    final List<BoxShadow> btnShadow;

    if (markedDone) {
      btnColor = AppColors.success;
      btnLabel = 'Completed Today!';
      btnIcon = Icons.check_circle_rounded;
      btnAction = null;
      btnShadow = [];
    } else if (!sessionStarted) {
      btnColor = AppColors.primaryTextColor;
      btnLabel = 'Start Exercise';
      btnIcon = Icons.play_arrow_rounded;
      btnAction = onStart;
      btnShadow = [];
    } else if (!allStepsDone) {
      btnColor = AppColors.primaryTextColor.withValues(alpha: 0.35);
      btnLabel = 'Complete Today';
      btnIcon = Icons.done_all_rounded;
      btnAction = null;
      btnShadow = [];
    } else {
      btnColor = AppColors.success;
      btnLabel = 'Complete Today';
      btnIcon = Icons.done_all_rounded;
      btnAction = onComplete;
      btnShadow = [
        BoxShadow(
          color: AppColors.success.withValues(alpha: 0.45),
          blurRadius: 20,
          offset: const Offset(0, 5),
        ),
      ];
    }

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h + bottomPad),
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        height: 54.h,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: btnShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: btnAction,
            child: SizedBox(
              height: 54.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(btnIcon, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    btnLabel,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Celebration Sheet ─────────────────────────────────────────────

class _CelebrationSheet extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onDone;
  const _CelebrationSheet({required this.exercise, required this.onDone});

  @override
  State<_CelebrationSheet> createState() => _CelebrationSheetState();
}

class _CelebrationSheetState extends State<_CelebrationSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _iconScale;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
      ),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final ex = widget.exercise;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding:
          EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 28.h + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 28.h),
          // Animated success icon
          ScaleTransition(
            scale: _iconScale,
            child: Container(
              width: 88.w,
              height: 88.h,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(Icons.check_rounded,
                  color: Colors.white, size: 44.sp),
            ),
          ),
          SizedBox(height: 22.h),
          // Animated content
          FadeTransition(
            opacity: _contentFade,
            child: SlideTransition(
              position: _contentSlide,
              child: Column(
                children: [
                  Text(
                    'Excellent Work! 💪',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    ex.name,
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor.withValues(alpha: 0.55),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${ex.sets} sets · ${ex.repsOrHold} · ${ex.durationLabel}',
                      style: GoogleFonts.dmSans(
                        color: AppColors.success,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Rest suggestion card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color:
                          AppColors.aiSugesstionCard.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.aiSugesstionCard
                            .withValues(alpha: 0.55),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.aiSugesstionCard,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.bedtime_rounded,
                              size: 20.sp,
                              color: AppColors.primaryTextColor),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time to Rest & Recover',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.primaryTextColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Give your muscles 20–30 minutes of rest before the next exercise. Proper recovery helps prevent strain and improves results.',
                                style: GoogleFonts.dmSans(
                                  color: AppColors.primaryTextColor
                                      .withValues(alpha: 0.6),
                                  fontSize: 12.sp,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Done button
                  GestureDetector(
                    onTap: widget.onDone,
                    child: Container(
                      width: double.infinity,
                      height: 54.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTextColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Back to Exercises',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
