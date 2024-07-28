import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class SvgTextContainer extends StatelessWidget {
  final String title;
  final bool isTapped;
  final VoidCallback onTap;
  final bool isSelected;

  const SvgTextContainer({
    super.key,
    required this.title,
    this.isTapped = false,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.h),
        decoration: BoxDecoration(
          color: isTapped ? primaryColor : textFieldBackColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        margin: isSelected ? null : EdgeInsets.only(bottom: 10.h),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isTapped ? Colors.white : null,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: SvgPicture.asset(
                  "assets/icons/OmIcon.svg",
                  width: 22.0,
                  height: 22.0,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: InterFontFamily.semiBold,
                  color: isTapped ? Colors.white : tertiaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
