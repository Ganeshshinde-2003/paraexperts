import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';

class VideoButtons extends StatelessWidget {
  final String category;
  final IconData? icon;
  final String svgIcon;
  const VideoButtons(
      {super.key,
      required this.category,
      required this.icon,
      this.svgIcon = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: customWhiteColor.withOpacity(0.2)),
      child: icon != null
          ? Icon(
              icon,
              color: customWhiteColor,
            )
          : SvgPicture.asset(
              svgIcon,
              fit: BoxFit.scaleDown,
            ),
    );
  }
}
