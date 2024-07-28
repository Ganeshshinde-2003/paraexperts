import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class CommonHeadTextWidget extends StatelessWidget {
  final String day;
  const CommonHeadTextWidget({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day.toUpperCase(),
          style: TextStyle(
            fontFamily: InterFontFamily.medium,
            fontSize: 15.sp,
            color: const Color(0xFF8A8A8A),
          ),
        ),
        Text(
          "Mark all as read",
          style: TextStyle(
            fontFamily: InterFontFamily.medium,
            fontSize: 14.sp,
            color: const Color(0xFF5000A0),
          ),
        ),
      ],
    );
  }
}
