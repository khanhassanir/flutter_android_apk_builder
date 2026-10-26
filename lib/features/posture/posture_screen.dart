import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';

class PostureScreen extends StatefulWidget {
  const PostureScreen({super.key});

  @override
  State<PostureScreen> createState() => _PostureScreenState();
}

class _PostureScreenState extends State<PostureScreen> {
  CameraController? _cameraCtrl;
  PoseDetector? _poseDetector;
  bool _isInitialized = false;
  bool _hasCameraPermission = false;
  bool _isAnalysing = false;
  String _feedback = 'Point your full body at the camera, then tap to analyse.';
  List<Pose> _poses = [];
  Size _poseImageSize = Size.zero;
  bool _unlocked = false;
  CameraDescription? _frontCamera;
  CameraDescription? _backCamera;
  bool _usingFront = true;
  String? _initError;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    _cameraCtrl?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() => _hasCameraPermission = true);
      if (_unlocked) _initCamera();
    } else if (status.isDenied) {
      final result = await Permission.camera.request();
      setState(() => _hasCameraPermission = result.isGranted);
      if (result.isGranted && _unlocked) _initCamera();
    } else {
      setState(() => _hasCameraPermission = false);
    }
  }

  Future<void> _initCamera() async {
    setState(() {
      _initError = null;
      _isInitialized = false;
    });
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No camera found on this device.');

      for (final cam in cameras) {
        if (cam.lensDirection == CameraLensDirection.front) _frontCamera = cam;
        if (cam.lensDirection == CameraLensDirection.back) _backCamera = cam;
      }

      final selected = _usingFront
          ? (_frontCamera ?? _backCamera ?? cameras.first)
          : (_backCamera ?? _frontCamera ?? cameras.first);

      _cameraCtrl = CameraController(
        selected,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraCtrl!.initialize();

      _poseDetector ??= PoseDetector(
        options: PoseDetectorOptions(mode: PoseDetectionMode.single),
      );

      if (mounted) setState(() => _isInitialized = true);
    } catch (_) {
      if (mounted) {
        setState(() => _initError = 'Camera failed to start. Tap Retry.');
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_isAnalysing) return;
    await _cameraCtrl?.dispose();
    _cameraCtrl = null;
    setState(() {
      _usingFront = !_usingFront;
      _isInitialized = false;
      _poses = [];
      _capturedImagePath = null;
      _feedback = _usingFront
          ? 'Point your full body at the camera, then tap to analyse.'
          : 'Prop your phone up · Stand sideways for full spine analysis.';
    });
    await _initCamera();
  }

  Future<void> _captureAndAnalyse() async {
    if (!_isInitialized || _isAnalysing || _cameraCtrl == null) return;
    setState(() {
      _isAnalysing = true;
      _capturedImagePath = null;
      _poses = [];
      _feedback = 'Analysing...';
    });

    try {
      final xFile = await _cameraCtrl!.takePicture();
      final inputImage = InputImage.fromFilePath(xFile.path);
      final poses = await _poseDetector!.processImage(inputImage);

      // Decode actual pixel dimensions for accurate landmark scaling
      final bytes = await File(xFile.path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final imageSize = Size(
        frame.image.width.toDouble(),
        frame.image.height.toDouble(),
      );

      if (mounted) {
        setState(() {
          _poses = poses;
          _poseImageSize = imageSize;
          _capturedImagePath = xFile.path;
          _feedback = _analyzePose(poses, imageSize);
        });
      }
    } catch (_) {
      if (mounted) setState(() => _feedback = 'Could not analyse — try again.');
    } finally {
      if (mounted) setState(() => _isAnalysing = false);
    }
  }

  void _resetToLive() {
    setState(() {
      _capturedImagePath = null;
      _poses = [];
      _feedback = _usingFront
          ? 'Point your full body at the camera, then tap to analyse.'
          : 'Prop your phone up · Stand sideways for full spine analysis.';
    });
  }

  void _unlock() {
    setState(() => _unlocked = true);
    if (_hasCameraPermission) {
      _initCamera();
    } else {
      _checkPermission();
    }
  }

  // ── Analysis logic ────────────────────────────────────────────

  String _analyzePose(List<Pose> poses, Size imageSize) {
    if (poses.isEmpty) {
      return 'No person detected — make sure your full body is in frame.';
    }

    final pose = poses.first;
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final nose = pose.landmarks[PoseLandmarkType.nose];
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];

    if (leftShoulder == null || rightShoulder == null || nose == null ||
        leftShoulder.likelihood < 0.5 || rightShoulder.likelihood < 0.5 ||
        nose.likelihood < 0.5) {
      return 'Face the camera and stand upright so your shoulders are visible.';
    }

    final w = imageSize.width;
    final h = imageSize.height;
    final midShoulderX = (leftShoulder.x + rightShoulder.x) / 2;
    final shoulderWidth = (leftShoulder.x - rightShoulder.x).abs();
    final isSideView = shoulderWidth < w * 0.10;

    if (isSideView) {
      // Side view — check forward head posture via ear offset
      final leftEar = pose.landmarks[PoseLandmarkType.leftEar];
      final rightEar = pose.landmarks[PoseLandmarkType.rightEar];
      final ear = ((leftEar?.likelihood ?? 0) >= (rightEar?.likelihood ?? 0))
          ? leftEar
          : rightEar;
      if (ear != null && ear.likelihood > 0.5) {
        final earForward = (ear.x - midShoulderX).abs();
        if (earForward > w * 0.08) {
          return '⚠️ Forward head posture — pull your chin back gently.';
        }
      }
      return '✅ Good posture! Keep it up.';
    }

    // Frontal view checks (normalised thresholds)
    final shoulderDiff = (leftShoulder.y - rightShoulder.y).abs();
    if (shoulderDiff > h * 0.05) {
      return '⚠️ Uneven shoulders — try to level them.';
    }

    final headOffset = (nose.x - midShoulderX).abs();
    if (headOffset > w * 0.07) {
      return '⚠️ Head is off-centre — align it with your shoulders.';
    }

    if (leftHip != null && rightHip != null &&
        leftHip.likelihood > 0.5 && rightHip.likelihood > 0.5) {
      final hipDiff = (leftHip.y - rightHip.y).abs();
      if (hipDiff > h * 0.05) {
        return '⚠️ Hips are uneven — check your weight distribution.';
      }
      final midHipX = (leftHip.x + rightHip.x) / 2;
      final spineOffset = (midShoulderX - midHipX).abs();
      if (spineOffset > w * 0.06) {
        return '⚠️ Body leaning to one side — try to align your spine.';
      }
    }

    return '✅ Good posture! Keep it up.';
  }

  // ── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PhysioAppBar(title: S.postureCheck),
      body: _unlocked ? _buildCamera() : _buildUnlockGate(),
    );
  }

  Widget _buildUnlockGate() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.camera_alt_outlined,
                color: AppColors.accent, size: 40),
          ),
          const SizedBox(height: 20),
          Text(S.posturePremium,
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(S.postureTagline,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Uses real-time AI pose detection, 100% offline.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          _FeatureChip(label: 'Head tilt detection'),
          const SizedBox(height: 8),
          _FeatureChip(label: 'Shoulder alignment check'),
          const SizedBox(height: 8),
          _FeatureChip(label: 'Spine & hip alignment'),
          const SizedBox(height: 8),
          _FeatureChip(label: 'Forward head posture (side view)'),
          const SizedBox(height: 36),
          PrimaryButton(label: 'Unlock Posture Check', onPressed: _unlock),
          const SizedBox(height: 12),
          const Text('Free for this session',
              style: TextStyle(fontSize: 12, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _buildCamera() {
    if (!_hasCameraPermission) {
      return Padding(
        padding: const EdgeInsets.all(AppConstants.pagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography_outlined,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(S.cameraPermissionRequired,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            PrimaryButton(
                label: 'Grant Camera Permission',
                onPressed: _checkPermission),
          ],
        ),
      );
    }

    if (_initError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.textHint),
              const SizedBox(height: 16),
              Text(_initError!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Retry', onPressed: _initCamera),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _cameraCtrl == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.accent),
            SizedBox(height: 16),
            Text('Starting camera...',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    // Show captured image + skeleton + result when analysis is done
    if (_capturedImagePath != null) {
      return _buildAnalysisView();
    }

    return _buildLiveView();
  }

  // Live camera preview with capture button
  Widget _buildLiveView() {
    final hasBackCamera = _backCamera != null;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        Positioned.fill(child: CameraPreview(_cameraCtrl!)),

        // Back camera usage tip
        if (!_usingFront)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: hasBackCamera ? 72 : 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Prop phone up · Stand sideways for spine & head check',
                style: TextStyle(color: Colors.white, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        // Camera flip button
        if (hasBackCamera)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: _switchCamera,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flip_camera_ios_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),

        // Bottom gradient + capture button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding:
                EdgeInsets.fromLTRB(24, 24, 24, bottomPad + 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.72),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isAnalysing)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('Analysing...',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  )
                else
                  Text(
                    _usingFront
                        ? 'Stand back so your full body is visible'
                        : 'Stand sideways for spine analysis',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 18),

                // Shutter button
                GestureDetector(
                  onTap: _isAnalysing ? null : _captureAndAnalyse,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(
                          alpha: _isAnalysing ? 0.4 : 1.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6),
                        width: 3.5,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isAnalysing
                            ? Colors.grey
                            : AppColors.accent,
                      ),
                      child: const Icon(
                        Icons.accessibility_new_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to analyse posture',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Captured image with skeleton overlay + result
  Widget _buildAnalysisView() {
    final isGood = _feedback.startsWith('✅');
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        // Captured photo with skeleton drawn over it
        Positioned.fill(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(_capturedImagePath!),
                    fit: BoxFit.cover,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                  ),
                  if (_poses.isNotEmpty && _poseImageSize != Size.zero)
                    CustomPaint(
                      painter: _PosePainter(
                        poses: _poses,
                        imageSize: _poseImageSize,
                        displaySize: Size(
                          constraints.maxWidth,
                          constraints.maxHeight,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        // Flip button still accessible
        if (_backCamera != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: _switchCamera,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flip_camera_ios_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),

        // Result + re-analyse button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding:
                EdgeInsets.fromLTRB(24, 24, 24, bottomPad + 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _feedback,
                  style: TextStyle(
                    color:
                        isGood ? const Color(0xFF80FF80) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: _resetToLive,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded,
                            color: AppColors.accent),
                        SizedBox(width: 8),
                        Text(
                          'Analyse again',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Feature chip ──────────────────────────────────────────────────

class _FeatureChip extends StatelessWidget {
  final String label;
  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_rounded,
            color: AppColors.accent, size: 16),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ── Skeleton painter ──────────────────────────────────────────────

class _PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final Size? displaySize; // when set, accounts for BoxFit.cover crop

  const _PosePainter({
    required this.poses,
    required this.imageSize,
    this.displaySize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;

    // Compute scale + offset to match BoxFit.cover if displaySize is provided
    double scaleX, scaleY, offsetX = 0, offsetY = 0;
    if (displaySize != null) {
      final fitScale = _coverScale(imageSize, displaySize!);
      scaleX = fitScale;
      scaleY = fitScale;
      offsetX = (displaySize!.width - imageSize.width * fitScale) / 2;
      offsetY = (displaySize!.height - imageSize.height * fitScale) / 2;
    } else {
      scaleX = size.width / imageSize.width;
      scaleY = size.height / imageSize.height;
    }

    Offset toPoint(PoseLandmark lm) =>
        Offset(lm.x * scaleX + offsetX, lm.y * scaleY + offsetY);

    for (final pose in poses) {
      for (final lm in pose.landmarks.values) {
        if (lm.likelihood > 0.5) {
          canvas.drawCircle(toPoint(lm), 4, dotPaint);
        }
      }

      void line(PoseLandmarkType a, PoseLandmarkType b) {
        final lmA = pose.landmarks[a];
        final lmB = pose.landmarks[b];
        if (lmA != null && lmB != null &&
            lmA.likelihood > 0.5 && lmB.likelihood > 0.5) {
          canvas.drawLine(toPoint(lmA), toPoint(lmB), paint);
        }
      }

      line(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
      line(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
      line(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
      line(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
      line(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
      line(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
      line(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
      line(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
      line(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
      line(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
      line(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
      line(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
    }
  }

  // Scale factor for BoxFit.cover: fills the display, may crop
  static double _coverScale(Size image, Size display) {
    return (display.width / image.width)
        .clamp(display.height / image.height, double.infinity);
  }

  @override
  bool shouldRepaint(_PosePainter old) =>
      old.poses != poses || old.imageSize != imageSize;
}
