import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/resources/data.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/packages/controllers/packages_controller.dart';
import 'package:paraexpert/features/packages/widgets/drop_down.dart';
import 'package:paraexpert/features/packages/widgets/input_field.dart';
import 'package:paraexpert/features/packages/widgets/range_selector.dart';
import 'package:paraexpert/features/packages/widgets/session_duraiton.dart';
import 'package:paraexpert/features/packages/widgets/toggle_bar.dart';

class CreatePackageScreen extends ConsumerStatefulWidget {
  const CreatePackageScreen({super.key});

  @override
  ConsumerState<CreatePackageScreen> createState() =>
      _CreatePackageScreenState();
}

class _CreatePackageScreenState extends ConsumerState<CreatePackageScreen> {
  bool isOnline = true;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> _selectedServices = [];
  int _selectedDays = 0;
  int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedAmount = 0;
  bool isLoading = false;

  void _handleRangeChanged(int values) {
    setState(() {
      _selectedAmount = values;
    });
  }

  void _handleSwitchChange(bool newValue) {
    setState(() {
      isOnline = newValue;
    });
  }

  void _handleSelectedItemsChanged(List<String> selectedItems) {
    setState(() {
      _selectedServices = selectedItems;
    });
  }

  void createPackage() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> packageData = {
      "title": titleController.text,
      "type": isOnline ? "online" : "offline",
      "description": descriptionController.text,
      "amount": _selectedAmount,
      "packageDuration":
          "$_selectedDays Days $_selectedHours Hours $_selectedMinutes Minutes",
      "services": _selectedServices,
    };

    await ref
        .read(packagesControllerProvider)
        .createPackage(context, packageData);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          leading: IconButton(
            padding: EdgeInsetsDirectional.only(start: 20.w),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              "assets/icons/back_button.svg",
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: OnlineOfflineSwitch(
                onChanged: _handleSwitchChange,
                width: 150.0,
                height: 30.0,
                isSmall: true,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Package",
                            style: TextStyle(
                              fontFamily: InterFontFamily.semiBold,
                              fontSize: 20.sp,
                              color: tertiaryTextColor,
                            ),
                          ),
                          Text(
                            "Create your costom Package",
                            style: TextStyle(
                              fontFamily: InterFontFamily.medium,
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 18.h),
                          CustomTextField(
                            controller: titleController,
                            title: 'Title',
                            isDescription: false,
                            hintText: 'Enter title',
                          ),
                          SizedBox(height: 16.h),
                          CustomTextField(
                            controller: descriptionController,
                            title: 'Description',
                            isDescription: true,
                            hintText: 'Enter description',
                          ),
                          SizedBox(height: 16.h),
                          DropdownContainer(
                            title: 'Type of Services',
                            items: AppData.packagesServices,
                            onSelectedItemsChanged: _handleSelectedItemsChanged,
                          ),
                          SizedBox(height: 16.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Session Duration",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomRowWidget(
                                    title: "Days",
                                    onNumberSelected: (number) {
                                      setState(() {
                                        _selectedDays = number;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10.w),
                                  CustomRowWidget(
                                    title: "Hrs",
                                    onNumberSelected: (number) {
                                      setState(() {
                                        _selectedHours = number;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10.w),
                                  CustomRowWidget(
                                    title: "Min",
                                    onNumberSelected: (number) {
                                      setState(() {
                                        _selectedMinutes = number;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: primaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 9.h,
                                ),
                                child: Text(
                                  "Your Time",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: InterFontFamily.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: textFieldBackColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 7.h,
                                    horizontal: 4.w,
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/clock.svg",
                                        height: 25.h,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "$_selectedDays Days $_selectedHours Hours $_selectedMinutes Minutes",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontFamily: InterFontFamily.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          IntSelector(
                            title: "Amount",
                            onValueChanged: _handleRangeChanged,
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [0.8, 1.0],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: GestureDetector(
                  onTap: () => createPackage(),
                  child: Container(
                    width: double.infinity,
                    height: 55.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Create",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontFamily: InterFontFamily.semiBold,
                              ),
                            ),
                    ),
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
