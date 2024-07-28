import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class OnlineOfflineSwitch extends StatefulWidget {
  final void Function(bool isOnline) onChanged;
  final double width;
  final double height;
  final bool isSmall;
  final bool value;

  const OnlineOfflineSwitch({
    super.key,
    required this.onChanged,
    this.width = 0.0,
    this.height = 35.0,
    this.isSmall = false,
    this.value = true,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OnlineOfflineSwitchState createState() => _OnlineOfflineSwitchState();
}

class _OnlineOfflineSwitchState extends State<OnlineOfflineSwitch> {
  late bool isOnline;

  @override
  void initState() {
    isOnline = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOnline = !isOnline;
        });
        widget.onChanged(isOnline);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.width == 0.0 ? double.infinity : widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
          border: Border.all(
            color: primaryColor,
            width: 1.0,
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment:
                  isOnline ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: widget.width == 0.0 ? 170.w : widget.width / 2,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontFamily: InterFontFamily.medium,
                    fontSize: widget.isSmall ? 12.sp : 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment:
                  isOnline ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  isOnline ? 'Offline' : 'Online',
                  style: TextStyle(
                    fontFamily: InterFontFamily.medium,
                    fontSize: widget.isSmall ? 12.sp : 18.sp,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
