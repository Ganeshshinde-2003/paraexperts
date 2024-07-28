import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:paraexpert/core/resources/data.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/booked_packages/models/all_packages.dart';

class PackagesItem extends StatefulWidget {
  final PackageData packages;

  const PackagesItem({
    super.key,
    required this.packages,
  });

  @override
  State<PackagesItem> createState() => _PackagesItemState();
}

class _PackagesItemState extends State<PackagesItem> {
  // int _selectedStars = 0;
  late String? appointmentID;

  @override
  void initState() {
    super.initState();
  }

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('d MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 20.h, start: 10.w, end: 10.w),
      child: Material(
        shadowColor: const Color(0xFF292D32),
        elevation: 2,
        borderRadius: BorderRadius.circular(24.r),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.pacakgeBookedDetails,
              arguments: {
                "packageId": widget.packages.packageId,
                "bookingId": widget.packages.id,
              },
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: secondaryColor,
              border: Border.all(
                color: customBlackColor.withOpacity(0.2),
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 15.w,
                vertical: 15.h,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.packages.bookingDate == null
                            ? ""
                            : _formatDate(
                                widget.packages.bookingDate.toString()),
                        style: TextStyle(
                            color: tertiaryColor,
                            fontFamily: InterFontFamily.semiBold,
                            fontSize: 15.sp),
                      ),
                      widget.packages.status == "scheduled"
                          ? Row(
                              children: [
                                Text(
                                  "Remind Me",
                                  style: TextStyle(
                                      fontFamily: InterFontFamily.regular,
                                      fontSize: 10.sp,
                                      color: tertiaryColor.withOpacity(0.5)),
                                ),
                                // Switch(
                                //   value: false,
                                //   onChanged: (value) {},
                                // ),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    height: 1.h,
                    width: MediaQuery.of(context).size.width,
                    color: customBlackColor.withOpacity(0.2),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80.r,
                        width: 80.r,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              widget.packages.userId.profilePicture
                                          .isNotEmpty ==
                                      true
                                  ? widget.packages.userId.profilePicture
                                      .toString()
                                  : AppData.userDefaultImage,
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.packages.userId.name,
                            style: TextStyle(
                              fontFamily: InterFontFamily.semiBold,
                              fontSize: 14.sp,
                              color: tertiaryColor,
                            ),
                          ),
                          // SizedBox(height: 10.h),
                          // Row(
                          //   children: [
                          //     Icon(
                          //       Iconsax.location,
                          //       color: customBlackColor,
                          //       size: 18.r,
                          //     ),
                          //     SizedBox(width: 5.w),
                          //     Text(
                          //       widget.appointments.userId?.name ??
                          //           "Loading...",
                          //       style: TextStyle(
                          //         fontFamily: InterFontFamily.regular,
                          //         fontSize: 11.sp,
                          //         color: tertiaryColor,
                          //       ),
                          //     )
                          //   ],
                          // ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              const Icon(Iconsax.card),
                              SizedBox(width: 2.w),
                              Text(
                                "Booking ID : ",
                                style: TextStyle(
                                    fontFamily: InterFontFamily.regular,
                                    fontSize: 11.sp,
                                    color: tertiaryColor),
                              ),
                              SizedBox(
                                width: 75,
                                child: Text(
                                  widget.packages.id,
                                  style: TextStyle(
                                    fontFamily: InterFontFamily.regular,
                                    fontSize: 11.sp,
                                    color: primaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Container(
                  //   height: 1.h,
                  //   width: MediaQuery.of(context).size.width,
                  //   color: customBlackColor.withOpacity(0.2),
                  // ),
                  // SizedBox(height: 10.h),
                  // widget.appointments.status != "cancelled"
                  //     ? Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           InkWell(
                  //             onTap: () {
                  //               if (widget.appointments.status == "scheduled") {
                  //                 // Navigator.pushNamed(
                  //                 //   context,
                  //                 //   AppRoutes.cancelAppointment,
                  //                 //   arguments: widget.bookingId,
                  //                 // );
                  //               }
                  //             },
                  //             child: AppointmentButton(
                  //               color: const Color(0xFFEFE0FF),
                  //               mul: 0.38,
                  //               text:
                  //                   widget.appointments.startTime == "scheduled"
                  //                       ? "Cancel"
                  //                       : "Re-Book",
                  //               textColor: onSecondaryTextColor,
                  //             ),
                  //           ),
                  //           InkWell(
                  //             onTap: () {
                  //               if (widget.appointments.status != "scheduled") {
                  //                 _showReviewSection(context);
                  //               } else {
                  //                 // showCustomDialog(context);
                  //               }
                  //             },
                  //             child: AppointmentButton(
                  //               color: primaryColor,
                  //               mul: 0.38,
                  //               text:
                  //                   widget.appointments.startTime == "scheduled"
                  //                       ? "Reschedule"
                  //                       : "Add Review",
                  //               textColor: onPrimaryTextColor,
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : const AppointmentButton(
                  //         color: primaryColor,
                  //         text: "Details",
                  //         textColor: onPrimaryTextColor,
                  //         mul: 0.8,
                  //       )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _showReviewSection(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 11,
  //         width: MediaQuery.of(context).size.width,
  //         decoration: BoxDecoration(
  //           color: secondaryColor,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(24.r),
  //             topRight: Radius.circular(24.r),
  //           ),
  //         ),
  //         child: Padding(
  //           padding: EdgeInsetsDirectional.fromSTEB(30.w, 10.h, 30.w, 0.h),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Align(
  //                 alignment: Alignment.topCenter,
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width * 0.2,
  //                   height: 5.h,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(Radius.circular(4.r)),
  //                       color: primaryColor),
  //                 ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xffFFF5E2),
  //                       borderRadius: BorderRadius.circular(50),
  //                     ),
  //                     padding:
  //                         EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
  //                     child: Text(
  //                       "Best Seller",
  //                       style: TextStyle(
  //                         color: const Color(0xffFCBB44),
  //                         fontSize: 16.sp,
  //                       ),
  //                     ),
  //                   ),
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SvgPicture.asset(
  //                         "assets/images/starFilled.svg",
  //                         fit: BoxFit.fill,
  //                         height: 15,
  //                         width: 15,
  //                       ),
  //                       SizedBox(width: 2.w),
  //                       Text(
  //                         "4.8 (332 Reviews)",
  //                         style: TextStyle(
  //                           color: customBlackColor,
  //                           fontFamily: InterFontFamily.regular,
  //                           fontSize: 12.sp,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 10.h),
  //               Text(
  //                 "Design Thinking Fundamental",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: tertiaryColor,
  //                   fontSize: 23.sp,
  //                   fontFamily: "Inter",
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               SizedBox(height: 7.h),
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.person,
  //                     color: const Color(0xff929292),
  //                     size: 30.r,
  //                   ),
  //                   SizedBox(width: 10.w),
  //                   Text(
  //                     "Robert Green",
  //                     style: TextStyle(
  //                       color: const Color(0xff929292),
  //                       fontSize: 16.sp,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 15.h),
  //               Container(
  //                 height: 1.h,
  //                 width: MediaQuery.of(context).size.width,
  //                 color: customBlackColor.withOpacity(0.2),
  //               ),
  //               SizedBox(height: 25.h),
  //               Center(
  //                 child: Text(
  //                   "Your overall rating for this course",
  //                   style: TextStyle(
  //                     color: const Color(0xff929292),
  //                     fontSize: 16.sp,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 5.h),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: List.generate(
  //                   5,
  //                   (index) => GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         _selectedStars = index + 1;
  //                       });
  //                     },
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 5.w),
  //                       child: SvgPicture.asset(
  //                         height: 50,
  //                         width: 50,
  //                         index < _selectedStars
  //                             ? "assets/images/starFilled.svg"
  //                             : "assets/images/star.svg",
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 20.h),
  //               Text(
  //                 "Add detailed review",
  //                 textAlign: TextAlign.start,
  //                 style: TextStyle(
  //                   color: tertiaryColor,
  //                   fontSize: 14.sp,
  //                   fontFamily: InterFontFamily.medium,
  //                 ),
  //               ),
  //               SizedBox(height: 2.h),
  //               Container(
  //                 height: 100,
  //                 width: MediaQuery.of(context).size.width,
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: const Color(0xffD9D9D9)),
  //                   borderRadius: BorderRadius.circular(20.r),
  //                 ),
  //                 child: TextField(
  //                   decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.symmetric(
  //                       vertical: 10.h,
  //                       horizontal: 10.w,
  //                     ),
  //                     hintText: "Enter here",
  //                     hintStyle: TextStyle(fontSize: 12.sp),
  //                     border: InputBorder.none,
  //                   ),
  //                   onChanged: (value) {},
  //                 ),
  //               ),
  //               SizedBox(height: 20.h),
  //               Container(
  //                 height: 45.h,
  //                 decoration: const BoxDecoration(
  //                   color: primaryColor,
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(40),
  //                   ),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     "Submit",
  //                     style: TextStyle(
  //                       fontSize: 16.sp,
  //                       color: secondaryColor,
  //                       fontFamily: InterFontFamily.semiBold,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class AppointmentButton extends StatelessWidget {
  final Color color;
  final double mul;
  final String text;
  final Color textColor;
  const AppointmentButton(
      {super.key,
      required this.color,
      required this.text,
      required this.textColor,
      required this.mul});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50.h,
        width: MediaQuery.of(context).size.width * mul,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontFamily: InterFontFamily.regular,
              fontSize: 15.sp,
              color: textColor),
        ),
      ),
    );
  }
}
