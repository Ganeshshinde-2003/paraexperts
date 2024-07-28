import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(
          fontFamily: InterFontFamily.regular,
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
      backgroundColor: primaryColor.withOpacity(0.9),
      duration: const Duration(milliseconds: 1500),
    ),
  );
}
