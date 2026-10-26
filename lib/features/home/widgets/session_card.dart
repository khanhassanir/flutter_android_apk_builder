import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/core/utils/app_localizations.dart';
import 'package:physioai/data/models/assessment_result.dart';
import 'package:physioai/features/home/all_sessions_screen.dart';
import 'package:physioai/providers/assessment_provider.dart';
import 'package:provider/provider.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({super.key});

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

  static String _subtitle(AssessmentResult r) {
    final date = DateFormat('dd MMM').format(r.date);
    if (r.source == 'chat') {
      return '$date\nChat\nDiagnosis';
    }
    return '$date\n${_painLabel(r.painType)} Pain\n${r.intensity}/10';
  }

  @override
  Widget build(BuildContext context) {
    final latest = context.watch<AssessmentProvider>().lastAssessment;

    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AllSessionsScreen()),
        ),
        child: Container(
          height: 170.h,
          width: 200.w,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: AppColors.recentSessionCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Text content ─────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(14, 20, 4, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      latest != null
                          ? S.areaLabel(latest.area)
                          : 'No Session',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      latest != null
                          ? _subtitle(latest)
                          : DateFormat('dd MMM').format(DateTime.now()),
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

              // ── Decorative image ──────────────────────────────
              Positioned(
                bottom: 12.h,
                right: -15.w,
                child: Image.asset(
                  "assets/session_icon.png",
                  height: 104.h,
                  width: 88.w,
                  fit: BoxFit.contain,
                ),
              ),

              // ── View All pill ─────────────────────────────────
              Positioned(
                bottom: 20.h,
                left: 14.w,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.recentSessionCardPill,
                    borderRadius:
                        BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 2.0),
                    child: Text(
                      'View All',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
