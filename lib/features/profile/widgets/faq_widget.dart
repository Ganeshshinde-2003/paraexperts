import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class ExpandableFAQItem extends StatefulWidget {
  final String headText;
  final String discText;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableFAQItem({
    super.key,
    required this.headText,
    required this.discText,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableFAQItemState createState() => _ExpandableFAQItemState();
}

class _ExpandableFAQItemState extends State<ExpandableFAQItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _heightFactor =
        _animationController.drive(CurveTween(curve: Curves.easeInOut));

    if (widget.isExpanded) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ExpandableFAQItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animationController.view,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: textFieldBackColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color.fromARGB(255, 238, 238, 238),
                  width: 1.w,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.headText,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: InterFontFamily.semiBold,
                        ),
                      ),
                      Icon(
                        widget.isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 24.sp,
                      ),
                    ],
                  ),
                  ClipRect(
                    child: Align(
                      heightFactor: _heightFactor.value,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            const Divider(color: Colors.grey),
                            Text(
                              widget.discText,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
