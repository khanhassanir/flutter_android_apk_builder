import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';

class AiAnalyzingWidget extends StatefulWidget {
  const AiAnalyzingWidget({super.key});

  @override
  State<AiAnalyzingWidget> createState() => _AiAnalyzingWidgetState();
}

class _AiAnalyzingWidgetState extends State<AiAnalyzingWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _ringController;
  late Animation<double> _pulseAnim;
  late Animation<double> _ringAnim;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _ringAnim =
        Tween<double>(begin: 0.0, end: 1.0).animate(_ringController);

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return false;
      setState(() => _dotCount = (_dotCount + 1) % 4);
      return true;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_pulseAnim, _ringAnim]),
          builder: (_, __) => Stack(
            alignment: Alignment.center,
            children: [
              // Rotating ring
              Transform.rotate(
                angle: _ringAnim.value * 2 * 3.14159,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: 0.0),
                        AppColors.accent.withValues(alpha: 0.8),
                        AppColors.accent.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Outer pulse ring
              Container(
                width: 120 * _pulseAnim.value,
                height: 120 * _pulseAnim.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.08),
                ),
              ),
              // Inner circle with icon
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.psychology_rounded,
                    color: Colors.white, size: 44),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          '${S.analyzingTitle}${'.' * _dotCount}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          S.analyzingSubtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _AnalysisStep(label: 'Mapping symptom patterns', delay: 0),
        const SizedBox(height: 8),
        _AnalysisStep(label: 'Cross-referencing condition database', delay: 600),
        const SizedBox(height: 8),
        _AnalysisStep(label: 'Generating personalized exercise plan', delay: 1400),
      ],
    );
  }
}

class _AnalysisStep extends StatefulWidget {
  final String label;
  final int delay;
  const _AnalysisStep({required this.label, required this.delay});

  @override
  State<_AnalysisStep> createState() => _AnalysisStepState();
}

class _AnalysisStepState extends State<_AnalysisStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.accent, size: 16),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
