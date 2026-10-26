import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/providers/progress_provider.dart';
import 'package:provider/provider.dart';

class MoodRow extends StatefulWidget {
  const MoodRow();

  @override
  State<MoodRow> createState() => _MoodRowState();
}

class _MoodRowState extends State<MoodRow> with TickerProviderStateMixin {
  int _selected = -1;
  bool _showEmojis = false;
  int _seq = 0; // incremented on each sequence start to cancel stale callbacks

  static const _moods = [
    (1, '😊', 'Calm'),
    (2, '😀', 'Happy'),
    (3, '😞', 'Sad'),
    (4, '😰', 'Anxious'),
    (5, '😡', 'Angry'),
  ];

  late final AnimationController _questionController;
  late final Animation<double> _questionFade;
  late final Animation<Offset> _questionSlide;

  late final AnimationController _cursorController;

  late final AnimationController _emojiController;

  @override
  void initState() {
    super.initState();

    final existing = context.read<ProgressProvider>().todayCheckIn;
    if (existing != null) _selected = existing;

    _questionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _questionFade =
        CurvedAnimation(parent: _questionController, curve: Curves.easeOut);
    _questionSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _questionController, curve: Curves.easeOut));

    _cursorController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 530))
      ..repeat(reverse: true);

    _emojiController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _startSequence();
  }

  @override
  void reassemble() {
    super.reassemble();
    _questionController.reset();
    _emojiController.reset();
    setState(() => _showEmojis = false);
    _startSequence();
  }

  void _startSequence() {
    final seq = ++_seq;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _seq != seq) return;
      _questionController.forward();
    });

    Future.delayed(const Duration(milliseconds: 4000), () {
      if (!mounted || _seq != seq) return;
      setState(() => _showEmojis = true);
      _emojiController.forward();
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _cursorController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  Animation<double> _emojiScale(int i) => CurvedAnimation(
    parent: _emojiController,
    curve: Interval(
      i * 0.1,
      (i * 0.1 + 0.6).clamp(0.0, 1.0),
      curve: Curves.easeOutBack,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        height: 72.h,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
          child: _showEmojis ? _buildEmojiRow() : _buildQuestion(),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    return FadeTransition(
      key: const ValueKey('question'),
      opacity: _questionFade,
      child: SlideTransition(
        position: _questionSlide,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'How are you feeling?',
                    textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    speed: const Duration(milliseconds: 200),
                    cursor: '',
                  ),
                ],
                totalRepeatCount: 1,
                pause: Duration.zero,
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              SizedBox(width: 5.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiRow() {
    return Row(
      key: const ValueKey('emojis'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _moods.asMap().entries.map((entry) {
        final i = entry.key;
        final mood = entry.value;
        final isSelected = _selected == mood.$1;

        return ScaleTransition(
          scale: _emojiScale(i),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              setState(() => _selected = mood.$1);
              await context.read<ProgressProvider>().saveCheckIn(mood.$1);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutBack,
                    style: TextStyle(fontSize: isSelected ? 44 : 26),
                    child: Text(mood.$2),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isSelected ? 0.0 : 1.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 3.h),
                        Text(
                          mood.$3,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryTextColor
                                .withValues(alpha: 0.6),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}