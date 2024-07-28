import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class OnBoardingSubtitleTitle extends StatelessWidget {
  final String title;
  final TextAlign align;
  final Color color;
  const OnBoardingSubtitleTitle({
    super.key,
    required this.title,
    required this.align,
    this.color = secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: align,
      style: TextStyle(
        fontSize: 14.sp,
        height: 1.0.h,
        color: color,
        fontFamily: InterFontFamily.medium,
      ),
    );
  }
}
