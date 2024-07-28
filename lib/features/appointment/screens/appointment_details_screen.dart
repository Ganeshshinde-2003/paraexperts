import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:paraexpert/core/resources/data.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/agora_services/screens/video_call.dart';
import 'package:paraexpert/features/appointment/controller/all_appointment.dart';
import 'package:paraexpert/features/appointment/models/appoinment_details_model.dart';
import 'package:paraexpert/features/appointment/widgets/row_widget.dart';

class AppointmentDetailsPage extends ConsumerStatefulWidget {
  final String bookingID;
  const AppointmentDetailsPage({
    super.key,
    required this.bookingID,
  });

  @override
  ConsumerState<AppointmentDetailsPage> createState() =>
      _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState
    extends ConsumerState<AppointmentDetailsPage> {
  AppointmentDetailsData? appointmentData;
  String startTime = "";
  String endTime = "";
  bool makeCall = false;
  bool isLoading = false;

  void fetchAppointmentDetail() async {
    setState(() {
      isLoading = true;
    });
    AppointmentDetailModel? data = await ref
        .read(getAppointmentsControllerProvider)
        .getAppointmentByID(context, widget.bookingID);
    appointmentData = data?.data;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAppointmentDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: primaryColor),
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
          title: Text(
            "My Appointment",
            style: TextStyle(
              fontFamily: InterFontFamily.semiBold,
              fontSize: 22.sp,
              color: const Color(0xFF20043C),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                appointmentData!.appointment.userId
                                            .profilePicture.isNotEmpty ==
                                        true
                                    ? appointmentData!
                                        .appointment.userId.profilePicture
                                        .toString()
                                    : AppData.userDefaultImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200.w,
                                child: Text(
                                  capitalize(appointmentData
                                          ?.appointment.userId.name ??
                                      "Loading..."),
                                  style: TextStyle(
                                    fontFamily: InterFontFamily.bold,
                                    fontSize: 22.sp,
                                    color: const Color(0xFF20043C),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Text(
                              //   'ParaExpert',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey[600],
                              //   ),
                              // ),
                              // SizedBox(height: 10.h),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Iconsax.location5,
                              //       color: primaryColor,
                              //       size: 20.r,
                              //     ),
                              //     SizedBox(width: 5.w),
                              //     Text(
                              //       capitalize(appointmentData?.paraExpert?.basedOn ??
                              //           "Loading..."),
                              //       style: TextStyle(
                              //         fontSize: 12.sp,
                              //         color: primaryColor,
                              //         fontFamily: InterFontFamily.regular,
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      height: 1.h,
                      width: MediaQuery.of(context).size.width,
                      color: customBlackColor.withOpacity(0.2),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Scheduled Appoinment',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontFamily: InterFontFamily.semiBold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    RowDetailsWidget(
                      title: "Date",
                      value: formatDate(
                        appointmentData?.appointment.date.toString() ??
                            "2024-06-06T21:13:35.473Z",
                      ),
                    ),
                    SizedBox(height: 10.h),
                    RowDetailsWidget(
                        title: "Time",
                        value:
                            "${_formatTime(appointmentData?.appointment.startTime)} - ${_formatTime(appointmentData?.appointment.endTime)} (01 hour)"),
                    SizedBox(height: 10.h),
                    const RowDetailsWidget(title: "Booking for", value: "Self"),
                    SizedBox(height: 10.h),
                    RowDetailsWidget(
                      title: "Appointment mode",
                      value: capitalize(
                          appointmentData?.appointment.appointmentMode ??
                              "Loading..."),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      height: 1.h,
                      width: MediaQuery.of(context).size.width,
                      color: customBlackColor.withOpacity(0.2),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Patient Info',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontFamily: InterFontFamily.semiBold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    RowDetailsWidget(
                      title: "Name",
                      value: capitalize(
                        appointmentData?.appointment.userId.name ??
                            "Loading...",
                      ),
                    ),
                    SizedBox(height: 10.h),
                    RowDetailsWidget(
                      title: "Problems",
                      value:
                          appointmentData?.appointment.problem.isEmpty ?? true
                              ? "------"
                              : appointmentData?.appointment.problem
                                      .map((e) => capitalize(e))
                                      .join(", ") ??
                                  "Loading...",
                    ),
                    SizedBox(height: 10.h),
                    if (appointmentData?.appointment.status == "rescheduled")
                      RowDetailsWidget(
                        title: "Reason for Reschedule",
                        value: capitalize(
                          appointmentData?.appointment.reason ?? "Loading...",
                        ),
                      ),
                  ],
                ),
        ),
        bottomNavigationBar: (appointmentData?.appointment.status ==
                    "scheduled" ||
                appointmentData?.appointment.status == "rescheduled")
            ? Padding(
                padding: EdgeInsets.only(bottom: 30.h, left: 20.w, right: 20.w),
                child: InkWell(
                  onTap: () {
                    appointmentData?.appointment.appointmentMethod ==
                            "video_call"
                        ? Navigator.pushNamed(
                            context,
                            AppRoutes.videoCall,
                            arguments: CallArgs(
                                callToken:
                                    appointmentData?.appointment.callToken,
                                userName:
                                    appointmentData?.appointment.userId.name),
                          )
                        : Navigator.pushNamed(
                            context,
                            AppRoutes.audioCall,
                            arguments: CallArgs(
                                callToken:
                                    appointmentData?.appointment.callToken,
                                userName:
                                    appointmentData?.appointment.userId.name),
                          );
                  },
                  child: Container(
                    height: 45.h,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.call,
                            color: primaryColor,
                            size: 25,
                          ),
                        ),
                        SizedBox(width: 95.w),
                        Text(
                          "Start Call",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: secondaryColor,
                            fontFamily: InterFontFamily.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat.yMMMMd().format(dateTime);
  }

  String capitalize(String? str) {
    if (str == null || str.isEmpty) return '';
    return str.replaceRange(0, 1, str[0].toUpperCase());
  }

  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return '00:00';
    }
    try {
      final time = DateFormat.Hm().parse(timeString);
      final formattedTime = DateFormat.jm().format(time);
      return formattedTime;
    } catch (e) {
      return '00:00';
    }
  }
}
