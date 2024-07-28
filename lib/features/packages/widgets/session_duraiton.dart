import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class CustomRowWidget extends StatefulWidget {
  final String title;
  final Function(int) onNumberSelected;
  final int value;

  const CustomRowWidget({
    super.key,
    required this.title,
    required this.onNumberSelected,
    this.value = 0,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomRowWidgetState createState() => _CustomRowWidgetState();
}

class _CustomRowWidgetState extends State<CustomRowWidget> {
  late int _selectedNumber;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedNumber = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showNumberPicker(context),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: const BoxDecoration(
              color: primaryColor,
              border: Border(
                top: BorderSide(color: primaryColor),
                bottom: BorderSide(color: primaryColor),
                left: BorderSide(color: primaryColor),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            child: Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: InterFontFamily.semiBold),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              _selectedNumber.toString(),
              style: const TextStyle(
                fontSize: 16.0,
                fontFamily: InterFontFamily.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNumberPicker(BuildContext context) {
    final overlayState = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + size.height + 8.0,
        left: position.dx + size.width - 55.0,
        width: 50.0,
        height: 150.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 40.0,
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListWheelScrollView.useDelegate(
              itemExtent: 30.0,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index > 60) {
                    return null;
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedNumber = index;
                      });
                      widget.onNumberSelected(index);
                      _overlayEntry?.remove();
                    },
                    child: Center(
                      child: Text(
                        index.toString(),
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  );
                },
                childCount: 61,
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }
}
