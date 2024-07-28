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
import 'package:paraexpert/features/booked_packages/controller/package_controller.dart';
import 'package:paraexpert/features/booked_packages/models/all_packages.dart';
import 'package:paraexpert/features/booked_packages/widgets/package.dart';

class BookedPackagesScreen extends ConsumerStatefulWidget {
  const BookedPackagesScreen({super.key});

  @override
  ConsumerState<BookedPackagesScreen> createState() =>
      _BookedPackagesScreenState();
}

class _BookedPackagesScreenState extends ConsumerState<BookedPackagesScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  bool isLoading = false;
  String status = "confirmed";
  GetAllPackageResponse? allPackageResponse;

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
        newStatus = "confirmed";
        break;
      case 1:
        newStatus = "rescheduled";
        break;
      case 2:
        newStatus = "pending";
        break;
      case 3:
        newStatus = "cancelled";
        break;
      default:
        newStatus = "confirmed";
    }

    allPackageResponse = await ref
        .read(getPackagesControllerProvider)
        .getAllPackages(context, newStatus);

    setState(() {
      isLoading = false;
      status = newStatus;
    });
  }

  Future<void> _handleRefresh() async {
    String newStatus;
    switch (tabController.index) {
      case 0:
        newStatus = "confirmed";
        break;
      case 1:
        newStatus = "rescheduled";
        break;
      case 2:
        newStatus = "pending";
        break;
      case 3:
        newStatus = "cancelled";
        break;
      default:
        newStatus = "confirmed";
    }

    allPackageResponse = await ref
        .read(getPackagesControllerProvider)
        .getAllPackages(context, newStatus);
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
                "Packages",
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
                      Tab(text: "Confirmed"),
                      Tab(text: "Reschedule"),
                      Tab(text: "Pending"),
                      Tab(text: "Cancel")
                    ]),
                SizedBox(height: 20.h),
                Expanded(
                  child: TabBarView(controller: tabController, children: [
                    buildAppointmentTab("confirmed"),
                    buildAppointmentTab("rescheduled"),
                    buildAppointmentTab("pending"),
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
        : PackageList(
            packages: allPackageResponse?.data
                    .where((package) => package.status == tabStatus)
                    .toList() ??
                [],
          );
  }
}

class PackageList extends StatelessWidget {
  final List<PackageData> packages;

  const PackageList({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    return packages.isEmpty
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
            itemCount: packages.length,
            itemBuilder: (context, index) {
              PackageData package = packages[packages.length - 1 - index];
              return PackagesItem(packages: package);
            },
          );
  }
}
