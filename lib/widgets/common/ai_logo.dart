import 'package:flutter/material.dart';

class AnimatedAssessment extends StatefulWidget {
  final double height;
  final double width;
  final Duration rotationDuration;
  final Duration pauseDuration;
  final Duration pulseDuration;

  const AnimatedAssessment({
    Key? key,
    required this.height,
    required this.width,
    this.rotationDuration = const Duration(milliseconds: 300), // Time taken for 90-degree rotation
    this.pauseDuration = const Duration(seconds: 3), // Pause between rotations
    this.pulseDuration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  State<AnimatedAssessment> createState() => _AnimatedAssessmentState();
}

class _AnimatedAssessmentState extends State<AnimatedAssessment>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  late AnimationController _pulseController1;
  late Animation<double> _pulseAnimation1;

  late AnimationController _pulseController2;
  late Animation<double> _pulseAnimation2;

  @override
  void initState() {
    super.initState();

    // Rotation animation with pause between rotations
    _rotationController = AnimationController(
      duration: widget.rotationDuration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );

    // Add listener to trigger next rotation after pause
    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Wait for pause duration, then reset and start again
        Future.delayed(widget.pauseDuration, () {
          if (mounted) {
            _rotationController.reset();
            _rotationController.forward();
          }
        });
      }
    });

    // Pulse animation for top-left image
    _pulseController1 = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _pulseAnimation1 = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _pulseController1,
        curve: Curves.easeInOut,
      ),
    );

    // Pulse animation for top-right image
    _pulseController2 = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _pulseAnimation2 = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _pulseController2,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _rotationController.forward(); // Start first rotation
    _pulseController1.repeat(reverse: true);
    _pulseController2.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController1.dispose();
    _pulseController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          // Center image with rotation (90 degrees, pause, then repeat)
          Center(
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Image.asset(
                    "assets/assesment.png",
                    height: widget.height * 0.6,
                    width: widget.width * 0.6,
                  ),
                );
              },
            ),
          ),

          // Top-left image with pulse effect
          Positioned(
            top: 0,
            left: widget.width * 0.13,
            child: AnimatedBuilder(
              animation: _pulseAnimation1,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation1.value,
                  child: Image.asset(
                    "assets/assesment.png",
                    height: widget.height * 0.27,
                    width: widget.width * 0.27,
                  ),
                );
              },
            ),
          ),

          // Top-right image with pulse effect
          Positioned(
            top: widget.height * 0.13,
            right: widget.width * 0.13,
            child: AnimatedBuilder(
              animation: _pulseAnimation2,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation2.value,
                  child: Image.asset(
                    "assets/assesment.png",
                    height: widget.height * 0.2,
                    width: widget.width * 0.2,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}