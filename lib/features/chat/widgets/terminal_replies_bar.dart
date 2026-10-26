import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/features/chat/chat_message.dart';

class TerminalRepliesBar extends StatelessWidget {
  final String? topic;
  final Set<String> usedKeys;
  final void Function(String key) onTap;

  const TerminalRepliesBar({
    super.key,
    required this.topic,
    required this.usedKeys,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final followupEntry = terminalFollowup[topic];
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You can still ask:',
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.38),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              if (followupEntry != null && !usedKeys.contains('followup'))
                _TerminalBubble(
                  icon: Icons.lightbulb_outline_rounded,
                  label: followupEntry.$1,
                  onTap: () => onTap('followup'),
                ),
              if (!usedKeys.contains('doctor'))
                _TerminalBubble(
                  icon: Icons.local_hospital_outlined,
                  label: 'When to see a doctor?',
                  onTap: () => onTap('doctor'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TerminalBubble extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TerminalBubble({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
              color: AppColors.primaryTextColor.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 13.sp,
                color: AppColors.primaryTextColor.withValues(alpha: 0.55)),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
