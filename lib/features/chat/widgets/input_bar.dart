import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';

class InputBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSend;
  final bool enabled;

  const InputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          top: BorderSide(
            color: AppColors.primaryTextColor.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                clipBehavior: Clip.none,
                cursorColor: AppColors.primaryTextColor,
                controller: controller,
                enabled: enabled,
                style: GoogleFonts.dmSans(
                  color: enabled
                      ? AppColors.primaryTextColor
                      : AppColors.primaryTextColor.withValues(alpha: 0.35),
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: enabled
                      ? 'Ask anything about your pain or exercises…'
                      : 'Use the suggestions above',
                  hintStyle: GoogleFonts.dmSans(
                    color: AppColors.textHint,
                    fontSize: 13.5.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 18.w, vertical: 13.h),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: enabled ? onSend : null,
                maxLines: null,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: enabled ? () => onSend(controller.text) : null,
            child: Container(
              width: 46.w,
              height: 46.h,
              decoration: BoxDecoration(
                color: enabled
                    ? AppColors.primaryTextColor
                    : AppColors.primaryTextColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: AppColors.primaryTextColor
                              .withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: Icon(
                Icons.arrow_upward_rounded,
                color: enabled ? Colors.white : Colors.white54,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
