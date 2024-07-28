import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/resources/data.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/packages/controllers/packages_controller.dart';
import 'package:paraexpert/features/packages/models/package_by_id_model.dart';
import 'package:paraexpert/features/packages/widgets/drop_down.dart';
import 'package:paraexpert/features/packages/widgets/input_field.dart';
import 'package:paraexpert/features/packages/widgets/range_selector.dart';
import 'package:paraexpert/features/packages/widgets/session_duraiton.dart';
import 'package:paraexpert/features/packages/widgets/toggle_bar.dart';

class EditPackageScreen extends ConsumerStatefulWidget {
  final String packageId;
  const EditPackageScreen({super.key, required this.packageId});

  @override
  ConsumerState<EditPackageScreen> createState() => _EditPackageScreenState();
}

class _EditPackageScreenState extends ConsumerState<EditPackageScreen> {
  PackageByIdResponse? packageData;

  bool isOnline = true;
  bool isLoading = false;
  bool isUpdating = false;
  bool isDeleting = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> _selectedServices = [];
  int _selectedDays = 0;
  int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedAmount = 0;
  final List<bool> _selectedServicesfromAPI =
      List<bool>.filled(AppData.packagesServices.length, false);
  int _selectedDaysfromAPI = 0;
  int _selectedHoursfromAPI = 0;
  int _selectedMinutesfromAPI = 0;
  int _selectedAmountfromAPI = 0;

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

  void updatePackage() async {
    setState(() {
      isUpdating = true;
    });
    Map<String, dynamic> packageDataById = {
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
        .updatePackage(context, widget.packageId, packageDataById);

    setState(() {
      isUpdating = false;
    });
  }

  void deletePackage() async {
    setState(() {
      isDeleting = true;
    });
    await ref
        .read(packagesControllerProvider)
        .deletePackage(context, widget.packageId);

    setState(() {
      isDeleting = false;
    });
  }

  @override
  void initState() {
    fetchPackageData();
    super.initState();
  }

  void fetchPackageData() async {
    setState(() {
      isLoading = true;
    });
    packageData = await ref.read(packagesControllerProvider).getPackageById(
          context,
          widget.packageId,
        );
    if (packageData == null) return;

    getDataFromAPI();

    setState(() {
      isLoading = false;
    });
  }

  void getDataFromAPI() {
    setState(() {
      isOnline = packageData!.data.type == "online";
      titleController.text = packageData!.data.title;
      descriptionController.text = packageData!.data.description;

      String packageDuration = packageData!.data.packageDuration;
      List<String> durationParts = packageDuration.split(' ');
      int days = int.parse(durationParts[0]);
      int hours = int.parse(durationParts[2]);
      int minutes = int.parse(durationParts[4]);

      _selectedDays = days;
      _selectedHours = hours;
      _selectedMinutes = minutes;
      _selectedAmount = packageData!.data.amount;

      _selectedDaysfromAPI = _selectedDays;
      _selectedHoursfromAPI = _selectedHours;
      _selectedMinutesfromAPI = _selectedMinutes;
      _selectedAmountfromAPI = _selectedAmount;

      List<String> backendServices = packageData!.data.services;
      _selectedServices = backendServices;
      for (int i = 0; i < AppData.packagesServices.length; i++) {
        _selectedServicesfromAPI[i] =
            backendServices.contains(AppData.packagesServices[i]);
      }
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
            isLoading
                ? Container()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: OnlineOfflineSwitch(
                      onChanged: _handleSwitchChange,
                      width: 150.0,
                      height: 30.0,
                      isSmall: true,
                      value: isOnline,
                    ),
                  ),
          ],
        ),
        body: Stack(
          children: [
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Edit Package",
                                  style: TextStyle(
                                    fontFamily: InterFontFamily.semiBold,
                                    fontSize: 20.sp,
                                    color: tertiaryTextColor,
                                  ),
                                ),
                                Text(
                                  "Edit your costom Package",
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
                                  onSelectedItemsChanged:
                                      _handleSelectedItemsChanged,
                                  values: _selectedServicesfromAPI,
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
                                          value: _selectedDaysfromAPI,
                                          onNumberSelected: (number) {
                                            setState(() {
                                              _selectedDays = number;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10.w),
                                        CustomRowWidget(
                                          title: "Hrs",
                                          value: _selectedHoursfromAPI,
                                          onNumberSelected: (number) {
                                            setState(() {
                                              _selectedHours = number;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10.w),
                                        CustomRowWidget(
                                          title: "Min",
                                          value: _selectedMinutesfromAPI,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                                fontFamily:
                                                    InterFontFamily.bold,
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
                                  initialValue: _selectedAmountfromAPI,
                                ),
                                SizedBox(height: 50.h),
                                GestureDetector(
                                  onTap: () => deletePackage(),
                                  child: Container(
                                    width: double.infinity,
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: const Color(0xffD14343),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                    ),
                                    child: Center(
                                      child: isDeleting
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              "Delete Package",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22.0,
                                                fontFamily:
                                                    InterFontFamily.semiBold,
                                              ),
                                            ),
                                    ),
                                  ),
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
                  onTap: () => updatePackage(),
                  child: Container(
                    width: double.infinity,
                    height: 55.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: isUpdating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Update Package",
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
