import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';

class CommonTextField extends StatefulWidget {
  final String title;
  final String hintText;
  final bool canEdit;
  final bool isDate;
  final bool isGender;
  final String value;
  final bool isPhone;
  final bool isTextField;
  final Function(String)? onUpdate;

  const CommonTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.canEdit = false,
    this.isDate = false,
    this.onUpdate,
    this.isGender = false,
    this.value = "",
    this.isPhone = false,
    this.isTextField = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  DateTime? selectedDate;
  String? selectedGender;
  // ignore: prefer_final_fields
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.value);
    _textEditingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onTextChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onUpdate != null) {
      widget.onUpdate!(_textEditingController.text);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? initialDate;

    if (widget.hintText == "dd/mm/yyyy") {
      initialDate = DateTime.now();
    } else if (widget.hintText.isNotEmpty && widget.hintText.contains('/')) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(widget.hintText);
      } catch (e) {
        initialDate = DateTime.now();
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      if (widget.onUpdate != null) {
        widget.onUpdate!(picked.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontFamily: InterFontFamily.medium,
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffF8F0FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.isDate
                    ? GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          absorbing: widget.isDate,
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.hintText,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: InterFontFamily.regular,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey,
                              fontFamily: InterFontFamily.medium,
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                                text: selectedDate != null
                                    ? formatter.format(selectedDate!)
                                    : null),
                          ),
                        ),
                      )
                    : widget.isGender
                        ? DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.hintText,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: InterFontFamily.regular,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            value: selectedGender,
                            onChanged: (newValue) {
                              setState(() {
                                selectedGender = newValue;
                                if (widget.onUpdate != null) {
                                  widget.onUpdate!(newValue!);
                                }
                              });
                            },
                            items: <String>[
                              'Select',
                              'male',
                              'female',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                    fontFamily: InterFontFamily.regular,
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.hintText,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: InterFontFamily.regular,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey,
                              fontFamily: InterFontFamily.medium,
                            ),
                            controller: _textEditingController,
                            readOnly: widget.isPhone,
                            maxLines: widget.isTextField ? 5 : 1,
                            keyboardType: widget.isPhone
                                ? TextInputType.number
                                : TextInputType.text,
                            inputFormatters: widget.isPhone
                                ? [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ]
                                : [],
                          ),
              ),
              if (widget.canEdit)
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15.sp,
                          fontFamily: InterFontFamily.medium,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
