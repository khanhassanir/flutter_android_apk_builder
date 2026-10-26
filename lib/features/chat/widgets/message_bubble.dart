import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/exercise_data.dart';
import 'package:physioai/data/plan_data.dart';
import 'package:physioai/features/chat/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final void Function(String id) onExerciseTap;
  final void Function(String id) onPlanTap;
  final VoidCallback onBrowseExercises;
  final VoidCallback onBrowsePlans;

  const MessageBubble({
    super.key,
    required this.message,
    required this.onExerciseTap,
    required this.onPlanTap,
    required this.onBrowseExercises,
    required this.onBrowsePlans,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 0.80.sw),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isUser
                  ? AppColors.primaryTextColor
                  : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? 20.r : 4.r),
                topRight: Radius.circular(isUser ? 4.r : 20.r),
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: GoogleFonts.dmSans(
                color: isUser
                    ? Colors.white
                    : AppColors.primaryTextColor,
                fontSize: 13.5.sp,
                height: 1.6,
              ),
            ),
          ),
          if (!isUser && message.exerciseIds.isNotEmpty) ...[
            SizedBox(height: 8.h),
            ExerciseChips(ids: message.exerciseIds, onTap: onExerciseTap),
          ],
          if (!isUser && message.planId != null) ...[
            SizedBox(height: 8.h),
            PlanChip(planId: message.planId!, onTap: onPlanTap),
          ],
          if (!isUser &&
              (message.exerciseIds.isNotEmpty ||
                  message.browseTarget == 'exercises')) ...[
            SizedBox(height: 6.h),
            BrowseButton(
              label: 'Browse all exercises',
              icon: Icons.fitness_center_rounded,
              onTap: onBrowseExercises,
            ),
          ],
          if (!isUser &&
              (message.planId != null ||
                  message.browseTarget == 'plans')) ...[
            SizedBox(height: 6.h),
            BrowseButton(
              label: 'Browse all plans',
              icon: Icons.calendar_month_rounded,
              onTap: onBrowsePlans,
            ),
          ],
        ],
      ),
    );
  }
}

class ExerciseChips extends StatelessWidget {
  final List<String> ids;
  final void Function(String id) onTap;

  const ExerciseChips({super.key, required this.ids, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: ids.map((id) {
        final ex = findExerciseById(id);
        if (ex == null) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => onTap(id),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: AppColors.aiSugesstionCard.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Icon(Icons.fitness_center_rounded,
                      size: 10.sp,
                      color: AppColors.primaryTextColor),
                ),
                SizedBox(width: 6.w),
                Text(
                  ex.name,
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5.w),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 9.sp,
                    color:
                        AppColors.primaryTextColor.withValues(alpha: 0.4)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class PlanChip extends StatelessWidget {
  final String planId;
  final void Function(String id) onTap;

  const PlanChip({super.key, required this.planId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final plan = findPlanById(planId);
    if (plan == null) return const SizedBox.shrink();
    final color = planCardColor(planId);
    return GestureDetector(
      onTap: () => onTap(planId),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.calendar_today_rounded,
                  size: 14.sp, color: AppColors.primaryTextColor),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recovery Plan',
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.5),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  plan.name,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 11.sp,
                color: AppColors.primaryTextColor.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}

class BrowseButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const BrowseButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primaryTextColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
              color: AppColors.primaryTextColor.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 12.sp,
                color: AppColors.primaryTextColor.withValues(alpha: 0.6)),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 5.w),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 9.sp,
                color: AppColors.primaryTextColor.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}
