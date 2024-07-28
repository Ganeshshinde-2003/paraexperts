import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class IntSelector extends StatefulWidget {
  final String title;
  final void Function(int) onValueChanged;
  final int initialValue;

  const IntSelector({
    super.key,
    required this.title,
    required this.onValueChanged,
    this.initialValue = 10,
  });

  @override
  // ignore: library_private_types_in_public_api
  _IntSelectorState createState() => _IntSelectorState();
}

class _IntSelectorState extends State<IntSelector> {
  late int _currentValue;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 213, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        bottomLeft: Radius.circular(8.r),
                      ),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/rupees.svg",
                      height: 25.h,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: SizedBox(
                      width: 80.w,
                      height: 20.h,
                      child: Center(
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontFamily: InterFontFamily.bold,
                          ),
                          onSubmitted: (value) {
                            int newValue = int.tryParse(value) ?? _currentValue;
                            if (newValue < 10) {
                              newValue = 10;
                            } else if (newValue > 20000) {
                              newValue = 20000;
                            }
                            setState(() {
                              _currentValue = newValue;
                              widget.onValueChanged(_currentValue);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Slider(
                value: _currentValue.toDouble(),
                min: 0,
                max: 20000,
                divisions: 1000,
                label: _currentValue.round().toString(),
                activeColor: primaryColor,
                inactiveColor: primaryColor.withOpacity(0.3),
                onChanged: (double value) {
                  setState(() {
                    _currentValue = value.toInt();
                    _controller.text = _currentValue.toString();
                    widget.onValueChanged(_currentValue);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
