// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/core/utils/on_will_pop_up.dart';
import 'package:paraexpert/features/appointment/controller/all_appointment.dart';
import 'package:paraexpert/features/appointment/models/appoinments_model.dart';
import 'package:paraexpert/features/appointment/widgets/appointment_widget.dart';

class AppointmentDetailsScreen extends ConsumerStatefulWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  ConsumerState<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState
    extends ConsumerState<AppointmentDetailsScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  AppointmentResponse? appointmentResponse;
  bool isLoading = false;
  String status = "scheduled";

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        updateAppointments();
      }
    });
    updateAppointments();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void updateAppointments() async {
    setState(() {
      isLoading = true;
    });
    String newStatus;
    switch (tabController.index) {
      case 0:
        newStatus = "scheduled";
        break;
      case 1:
        newStatus = "rescheduled";
        break;
      case 2:
        newStatus = "completed";
        break;
      case 3:
        newStatus = "cancelled";
        break;
      default:
        newStatus = "scheduled";
    }

    appointmentResponse = await ref
        .read(getAppointmentsControllerProvider)
        .getAllAppointments(context, newStatus);

    setState(() {
      isLoading = false;
      status = newStatus;
    });
  }

  Future<void> _handleRefresh() async {
    String newStatus;
    switch (tabController.index) {
      case 0:
        newStatus = "scheduled";
        break;
      case 1:
        newStatus = "rescheduled";
        break;
      case 2:
        newStatus = "completed";
        break;
      case 3:
        newStatus = "cancelled";
        break;
      default:
        newStatus = "scheduled";
    }

    appointmentResponse = await ref
        .read(getAppointmentsControllerProvider)
        .getAllAppointments(context, newStatus);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: primaryColor,
      animSpeedFactor: 4.0,
      springAnimationDurationInMilliseconds: 700,
      height: 130,
      showChildOpacityTransition: false,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () =>
              ConfirmExitDialog.showExitConfirmationDialog(context),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: secondaryColor,
              leading: IconButton(
                padding: EdgeInsetsDirectional.only(start: 20.w),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.bottomBar);
                },
                icon: SvgPicture.asset(
                  "assets/icons/back_button.svg",
                ),
              ),
              title: Text(
                "Appointment",
                style: TextStyle(
                  fontFamily: InterFontFamily.semiBold,
                  fontSize: 20.sp,
                  color: const Color(0xFF20043C),
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 20.w),
                  child: Container(
                    height: 40.r,
                    width: 40.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(12.r),
                      child: SvgPicture.asset(
                        "assets/icons/search.svg",
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                )
              ],
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                TabBar(
                    indicator: BoxDecoration(
                      color: secondaryColor,
                      border: Border(
                        bottom: BorderSide(
                          color: primaryColor,
                          width: 4.h,
                        ),
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    isScrollable: true,
                    controller: tabController,
                    labelColor: Colors.black,
                    labelPadding:
                        EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                    labelStyle: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: InterFontFamily.semiBold,
                      color: Colors.black,
                    ),
                    tabAlignment: TabAlignment.center,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: InterFontFamily.regular,
                      color: const Color(0xFF8A8A8A),
                    ),
                    tabs: const [
                      Tab(text: "Scheduled"),
                      Tab(text: "Reschedule"),
                      Tab(text: "Completed"),
                      Tab(text: "Cancel")
                    ]),
                SizedBox(height: 20.h),
                Expanded(
                  child: TabBarView(controller: tabController, children: [
                    buildAppointmentTab("scheduled"),
                    buildAppointmentTab("rescheduled"),
                    buildAppointmentTab("completed"),
                    buildAppointmentTab("cancelled"),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppointmentTab(String tabStatus) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : AppointmentList(
            appointments: appointmentResponse?.data
                    .where((appointment) => appointment.status == tabStatus)
                    .toList() ??
                [],
          );
  }
}

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentList({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return appointments.isEmpty
        ? Center(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                SvgPicture.asset(
                  "assets/images/nodata.svg",
                ),
                Text(
                  "No Appointments",
                  style: TextStyle(
                    fontFamily: InterFontFamily.semiBold,
                    fontSize: 20.sp,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              Appointment appointment =
                  appointments[appointments.length - 1 - index];
              return AppointmentItem(appointments: appointment);
            },
          );
  }
}
