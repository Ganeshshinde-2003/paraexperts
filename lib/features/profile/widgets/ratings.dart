import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;

  const RatingDisplay({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(
            i <= rating ? Icons.star : Icons.star_border,
            color: primaryColor,
            size: 20.sp,
          ),
        SizedBox(width: 10.w),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontFamily: 'InterFontFamily.medium',
          ),
        ),
      ],
    );
  }
}
