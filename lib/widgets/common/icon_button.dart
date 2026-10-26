import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:physioai/core/theme/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? svgAsset;


  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.svgAsset,
});
  @override
  Widget build(BuildContext context) {
    final flag = svgAsset == null ? false : true;
    return GestureDetector(
      onTap: onPressed,
      child: Container(

        width: 50.w,
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),

                blurRadius: 4.r,
                blurStyle: BlurStyle.normal
            )
          ],
        ),
        child: !flag ? Icon(
          icon,
          color: Colors.black
        ) :
        SvgPicture.asset(
          svgAsset!,
          width: 28.w,
          height: 28.h,
          colorFilter: ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn),
        )
        ,
      ),
    );
  }
}
