import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool isDescription;
  final String hintText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.isDescription,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: isDescription ? 5 : null,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: textFieldBackColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
