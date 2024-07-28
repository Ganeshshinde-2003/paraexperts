// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/packages/widgets/drop_down_element.dart';

class DropdownContainer extends StatefulWidget {
  final List<String> items;
  final String title;
  final ValueChanged<List<String>> onSelectedItemsChanged;
  final List<bool> values;

  const DropdownContainer({
    super.key,
    required this.items,
    required this.title,
    required this.onSelectedItemsChanged,
    this.values = const [],
  });

  @override
  _DropdownContainerState createState() => _DropdownContainerState();
}

class _DropdownContainerState extends State<DropdownContainer>
    with SingleTickerProviderStateMixin {
  bool _isDropdownOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  late List<bool> _tappedItems;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _tappedItems = List<bool>.filled(widget.items.length, false);
  }

  void _toggleDropdown() {
    setState(() {
      if (_isDropdownOpen) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _onItemTap(int index) {
    setState(() {
      _tappedItems[index] = !_tappedItems[index];
      widget.onSelectedItemsChanged(_getSelectedItems());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<String> _getSelectedItems() {
    List<String> selectedItems = [];
    for (int i = 0; i < _tappedItems.length; i++) {
      if (_tappedItems[i]) {
        selectedItems.add(widget.items[i]);
      }
    }
    return selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    // Get selected items
    List<String> selectedItems = [];
    if (widget.values.isNotEmpty) {
      _tappedItems = widget.values;
    }
    for (int i = 0; i < _tappedItems.length; i++) {
      if (_tappedItems[i]) {
        selectedItems.add(widget.items[i]);
      }
    }

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
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            width: double.infinity,
            padding: selectedItems.isEmpty
                ? EdgeInsets.all(14.h)
                : EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: textFieldBackColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
                bottomLeft:
                    _isDropdownOpen ? Radius.zero : Radius.circular(8.r),
                bottomRight:
                    _isDropdownOpen ? Radius.zero : Radius.circular(8.r),
              ),
              border: Border.all(color: Colors.grey),
            ),
            child: selectedItems.isEmpty
                ? const Text(
                    'Select services',
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 85, 85),
                      fontSize: 15,
                      fontFamily: InterFontFamily.medium,
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: selectedItems.map((item) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: SvgTextContainer(
                            title: item,
                            isTapped: true,
                            onTap: _toggleDropdown,
                            isSelected: true,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              border: Border.all(
                color: textFieldBackColor,
                width: 2.0,
              ),
            ),
            child: Wrap(
              spacing: 8.0,
              children: List.generate(widget.items.length, (index) {
                return SvgTextContainer(
                  title: widget.items[index],
                  isTapped: _tappedItems[index],
                  onTap: () => _onItemTap(index),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
