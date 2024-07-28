import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

String capitalizeTitle(String title) {
  return title.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

class PackagesWidget extends StatelessWidget {
  final String title;
  final String description;
  final String price;

  const PackagesWidget({
    super.key,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                capitalizeTitle(title),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: InterFontFamily.regular,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 25.w,
                width: 25.w,
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: SvgPicture.asset(
                  "assets/icons/tick.svg",
                ),
              )
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                "\u{20B9}$price",
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: InterFontFamily.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: InterFontFamily.regular,
            ),
          ),
        ],
      ),
    );
  }
}
