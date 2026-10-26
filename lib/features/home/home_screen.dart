import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/features/home/widgets/active_plan_card.dart';
import 'package:physioai/features/home/widgets/chat_card.dart';
import 'package:physioai/features/home/widgets/daily_assessment_card.dart';
import 'package:physioai/features/home/widgets/mode_deeling.dart';
import 'package:physioai/features/home/widgets/session_card.dart';
import 'package:physioai/features/home/widgets/social_card.dart';
import 'package:physioai/features/premium_excercise/premium_excercise_screen.dart';
import 'package:physioai/widgets/common/icon_button.dart';
import '../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          AppColors.backgroundColor,
          AppColors.backgroundColor2,
          AppColors.backgroundColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _TopBar(onSettingsTap: () => onNavigate(3)),
              const Divider(color: Color(0x33FFFFFF), height: 1, thickness: 1),
              const Expanded(child: _HomeBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onSettingsTap;

  const _TopBar({required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ExerciseScreen()),
            );
          }, icon: Icons.person),
          Column(
            children: [
              Text(
                'Hello, Hassan',
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Today: 25 May',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.secondaryTextColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          CustomIconButton(
            onPressed: onSettingsTap,
            icon: Icons.settings,
            svgAsset: "assets/svg/settings.svg",
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DailyAssessmentCard(),
          const ActivePlanCard(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),

                Container(
                  color: Colors.transparent,
                  height: 274.h,
                  width: double.infinity,
                  child: Row(
                    spacing: 6.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ChatCard()),
                      Expanded(
                          child: Column(
                        spacing: 6.w,
                        children: [
                          SessionCard(),
                          SocialCard(),
                        ],
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}