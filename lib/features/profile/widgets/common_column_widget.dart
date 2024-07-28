import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class CommonColumnWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  const CommonColumnWidget(
      {super.key, required this.title, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    iconPath,
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: InterFontFamily.medium,
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Image.asset(
                "assets/icons/back_arrow.png",
                width: 60,
                height: 60,
              ),
            ],
          ),
        ),
        Container(
          height: 1.h,
          width: MediaQuery.of(context).size.width,
          color: customBlackColor.withOpacity(0.2),
        ),
      ],
    );
  }
}
