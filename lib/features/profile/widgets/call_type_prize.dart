import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class NumberInputRow extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const NumberInputRow({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: InterFontFamily.semiBold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffF8F0FF),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter prize",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontFamily: InterFontFamily.regular,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                fontFamily: InterFontFamily.medium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
