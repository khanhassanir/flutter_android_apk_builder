import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/features/home/widgets/chat_button.dart';

class ChatCard extends StatelessWidget {
  const ChatCard();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        height: 274.h,
        width: 200.w,
        decoration: BoxDecoration(
          color: AppColors.aiSugesstionCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/chat_icon.png",
                    height: 80.h,
                    width: 80.w,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.aiSugesstionCardPill,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 2.0),
                        child: Text(
                          'Pysio Ai',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryTextColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Suggestions',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Get yourself a friendly suggestion!',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor.withValues(alpha: 0.6),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 44.h),
                  LetsChatButton(),
                ],
              ),
            ],
          ),
        ));
  }
}
