import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';

class BodyMapWidget extends StatefulWidget {
  final Set<String> selectedAreas;
  final void Function(String area) onAreaTapped;
  final bool multiSelect;

  const BodyMapWidget({
    super.key,
    required this.selectedAreas,
    required this.onAreaTapped,
    this.multiSelect = false,
  });

  @override
  State<BodyMapWidget> createState() => _BodyMapWidgetState();
}

class _BodyMapWidgetState extends State<BodyMapWidget> {
  bool _isFrontView = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ViewToggle(
          isFront: _isFrontView,
          onToggle: (v) => setState(() => _isFrontView = v),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              return Stack(
                children: [
                  CustomPaint(
                    size: Size(w, h),
                    painter: _BodyPainter(
                      selectedAreas: widget.selectedAreas,
                      isFront: _isFrontView,
                    ),
                  ),
                  ..._buildZones(w, h),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        if (widget.selectedAreas.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: widget.selectedAreas.map((a) => _AreaChip(area: a)).toList(),
          )
        else
          Text(
            S.tapOnBodyMap,
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  List<Widget> _buildZones(double w, double h) {
    const zones = <String, List<double>>{
      'neck':       [0.38, 0.10, 0.62, 0.19],
      'shoulders':  [0.08, 0.17, 0.92, 0.27],
      'upper_back': [0.24, 0.22, 0.76, 0.38],
      'lower_back': [0.24, 0.38, 0.76, 0.55],
      'hips':       [0.20, 0.54, 0.80, 0.64],
      'knees':      [0.22, 0.68, 0.78, 0.80],
      'ankles':     [0.28, 0.84, 0.72, 0.95],
    };

    return zones.entries.map((entry) {
      final r = entry.value;
      final left = r[0] * w;
      final top = r[1] * h;
      final width = (r[2] - r[0]) * w;
      final height = (r[3] - r[1]) * h;
      final isSelected = widget.selectedAreas.contains(entry.key);

      return Positioned(
        left: left,
        top: top,
        width: width,
        height: height,
        child: GestureDetector(
          onTap: () => widget.onAreaTapped(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.painHighlight.withValues(alpha: 0.35)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: AppColors.painHighlight, width: 2)
                  : null,
            ),
            child: isSelected
                ? Center(
                    child: Text(
                      S.areaLabel(entry.key),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : null,
          ),
        ),
      );
    }).toList();
  }
}

class _ViewToggle extends StatelessWidget {
  final bool isFront;
  final void Function(bool) onToggle;

  const _ViewToggle({required this.isFront, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: AppColors.dailyAssessment,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Tab(label: S.frontView, selected: isFront, onTap: () => onToggle(true)),
            _Tab(label: S.backView, selected: !isFront, onTap: () => onToggle(false)),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryTextColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AreaChip extends StatelessWidget {
  final String area;
  const _AreaChip({required this.area});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.painHighlight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.painHighlight.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, size: 12, color: AppColors.painHighlight),
          const SizedBox(width: 4),
          Text(
            S.areaLabel(area),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.painHighlight,
            ),
          ),
        ],
      ),
    );
  }
}

// ── CustomPainter ─────────────────────────────────────────────

class _BodyPainter extends CustomPainter {
  final Set<String> selectedAreas;
  final bool isFront;

  const _BodyPainter({required this.selectedAreas, required this.isFront});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bodyColor = const Color(0xFFD6C9B8);
    final paint = Paint()..color = bodyColor..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFFB8A898)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Head
    final headCenter = Offset(w * 0.5, h * 0.07);
    final headRx = w * 0.10;
    final headRy = h * 0.06;
    canvas.drawOval(Rect.fromCenter(center: headCenter, width: headRx * 2, height: headRy * 2), paint);
    canvas.drawOval(Rect.fromCenter(center: headCenter, width: headRx * 2, height: headRy * 2), strokePaint);

    // Neck
    final neckRect = Rect.fromLTWH(w * 0.44, h * 0.13, w * 0.12, h * 0.06);
    canvas.drawRect(neckRect, paint);

    // Torso (trapezoid shape)
    final torsoPath = Path()
      ..moveTo(w * 0.20, h * 0.19)
      ..lineTo(w * 0.80, h * 0.19)
      ..lineTo(w * 0.72, h * 0.57)
      ..lineTo(w * 0.28, h * 0.57)
      ..close();
    canvas.drawPath(torsoPath, paint);
    canvas.drawPath(torsoPath, strokePaint);

    // Hip area
    final hipPath = Path()
      ..moveTo(w * 0.26, h * 0.54)
      ..lineTo(w * 0.74, h * 0.54)
      ..lineTo(w * 0.72, h * 0.65)
      ..lineTo(w * 0.28, h * 0.65)
      ..close();
    canvas.drawPath(hipPath, paint);
    canvas.drawPath(hipPath, strokePaint);

    // Left arm
    _drawRoundedRect(canvas, paint, strokePaint, w * 0.07, h * 0.19, w * 0.13, h * 0.34, 6);

    // Right arm
    _drawRoundedRect(canvas, paint, strokePaint, w * 0.80, h * 0.19, w * 0.13, h * 0.34, 6);

    // Left upper leg
    _drawRoundedRect(canvas, paint, strokePaint, w * 0.28, h * 0.63, w * 0.18, h * 0.22, 6);

    // Right upper leg
    _drawRoundedRect(canvas, paint, strokePaint, w * 0.54, h * 0.63, w * 0.18, h * 0.22, 6);

    // Left lower leg + ankle
    _drawRoundedRect(canvas, paint, strokePaint, w * 0.29, h * 0.83, w * 0.15, h * 0.14, 6);

    // Right lower leg + ankle
    _drawRoundedRect(canvas, paint, strokePaint, w * 0.56, h * 0.83, w * 0.15, h * 0.14, 6);

    // Back-view detail: spine line
    if (!isFront) {
      final spinePaint = Paint()
        ..color = const Color(0xFFB8A898)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(w * 0.5, h * 0.19),
        Offset(w * 0.5, h * 0.57),
        spinePaint,
      );
    }
  }

  void _drawRoundedRect(Canvas canvas, Paint fill, Paint stroke,
      double x, double y, double w, double h, double r) {
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r));
    canvas.drawRRect(rect, fill);
    canvas.drawRRect(rect, stroke);
  }

  @override
  bool shouldRepaint(_BodyPainter old) =>
      old.selectedAreas != selectedAreas || old.isFront != isFront;
}
