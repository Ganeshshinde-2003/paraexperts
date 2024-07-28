import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:paraexpert/core/resources/data.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/appointment/widgets/row_widget.dart';
import 'package:paraexpert/features/booked_packages/controller/package_controller.dart';
import 'package:paraexpert/features/booked_packages/models/package_details_mode.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class PackageDetailsScreen extends ConsumerStatefulWidget {
  final String packageId;
  final String bookingId;
  const PackageDetailsScreen({
    super.key,
    required this.packageId,
    required this.bookingId,
  });

  @override
  ConsumerState<PackageDetailsScreen> createState() =>
      _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends ConsumerState<PackageDetailsScreen> {
  PackageBookedResponseModel? packageDetails;
  bool isLoading = false;
  @override
  void initState() {
    fetchPackageDetails();
    super.initState();
  }

  void fetchPackageDetails() async {
    setState(() {
      isLoading = true;
    });
    packageDetails =
        await ref.read(getPackagesControllerProvider).getPackageById(
              context,
              widget.packageId,
              widget.bookingId,
            );

    setState(() {
      isLoading = false;
    });
  }

  void _updateStatus(String status) async {
    setState(() {
      isLoading = true;
    });
    ref
        .read(getPackagesControllerProvider)
        .updatePackageStatus(context, status, widget.bookingId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _downloadPresctiption(link) async {
    launcher.launchUrl(
      Uri.parse(link),
    );
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
          title: Text(
            "My Package",
            style: TextStyle(
              fontFamily: InterFontFamily.semiBold,
              fontSize: 20.sp,
              color: const Color(0xFF20043C),
            ),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
            : Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 0),
                    child: SingleChildScrollView(
                      child: Column(
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
                                      packageDetails!.data.bookings.userId
                                                  .profilePicture.isNotEmpty ==
                                              true
                                          ? packageDetails!.data.bookings.userId
                                              .profilePicture
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
                                        capitalize(packageDetails!
                                            .data.bookings.userId.name),
                                        style: TextStyle(
                                          fontFamily: InterFontFamily.bold,
                                          fontSize: 22.sp,
                                          color: const Color(0xFF20043C),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
                            'Scheduled Package',
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
                                packageDetails!.data.bookings.bookingDate),
                          ),
                          SizedBox(height: 10.h),
                          const RowDetailsWidget(
                              title: "Booking for", value: "Self"),
                          SizedBox(height: 10.h),
                          RowDetailsWidget(
                            title: "Location",
                            value: capitalize(
                                packageDetails!.data.bookings.location),
                          ),
                          SizedBox(height: 10.h),
                          RowDetailsWidget(
                            title: "Adress",
                            value: capitalize(
                                packageDetails!.data.bookings.address),
                          ),
                          if (packageDetails!.data.bookings.questions != null)
                            SizedBox(height: 10.h),
                          if (packageDetails!.data.bookings.questions != null)
                            RowDetailsWidget(
                              title: "Questions",
                              value: capitalize(
                                  packageDetails!.data.bookings.questions),
                            ),
                          SizedBox(height: 20.h),
                          Container(
                            height: 1.h,
                            width: MediaQuery.of(context).size.width,
                            color: customBlackColor.withOpacity(0.2),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Package Info',
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
                                packageDetails!.data.packageDetail.title),
                          ),
                          SizedBox(height: 10.h),
                          RowDetailsWidget(
                            title: "Description",
                            value: capitalize(
                                packageDetails!.data.packageDetail.description),
                          ),
                          SizedBox(height: 10.h),
                          RowDetailsWidget(
                            title: "Mode",
                            value: capitalize(
                                packageDetails!.data.packageDetail.type),
                          ),
                          SizedBox(height: 10.h),
                          RowDetailsWidget(
                            title: "Duration",
                            value: capitalize(packageDetails!
                                .data.packageDetail.packageDuration),
                          ),
                          SizedBox(height: 10.h),
                          RowDetailsWidget(
                            title: "Services",
                            value: packageDetails!
                                    .data.packageDetail.services.isEmpty
                                ? "------"
                                : packageDetails!.data.packageDetail.services
                                    .map((e) => capitalize(e))
                                    .join(", "),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Download Prescription",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  fontFamily: InterFontFamily.regular,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => {
                                  if (packageDetails!.data.bookings
                                      .prescriptionReport.isNotEmpty)
                                    _downloadPresctiption(packageDetails!
                                        .data.bookings.prescriptionReport)
                                },
                                child: Expanded(
                                  child: Text(
                                    packageDetails!.data.bookings
                                            .prescriptionReport.isEmpty
                                        ? "No Prescription"
                                        : "Download",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: primaryColor,
                                      fontFamily: InterFontFamily.bold,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                  if (packageDetails!.data.bookings.status == "pending")
                    Positioned(
                      bottom: 10.h,
                      left: 20.w,
                      right: 20.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _updateStatus("confirmed"),
                            child: Container(
                              width: (MediaQuery.of(context).size.width / 2) -
                                  30.w,
                              height: 45.h,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: InterFontFamily.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _updateStatus("cancelled"),
                            child: Container(
                              width: (MediaQuery.of(context).size.width / 2) -
                                  30.w,
                              height: 45.h,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Decline',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: InterFontFamily.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
      ),
    );
  }

  String capitalize(String? str) {
    if (str == null || str.isEmpty) return '';
    return str.replaceRange(0, 1, str[0].toUpperCase());
  }

  String formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(date);
  }
}
