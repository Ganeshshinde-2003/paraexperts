import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/notifications/controller/notification_controller.dart';
import 'package:paraexpert/features/notifications/models/notification_model.dart';
import 'package:paraexpert/features/notifications/widgets/notification_widget.dart';
import 'package:paraexpert/features/profile/widgets/common_head_disc_widget.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  List<NotificationDataEntity>? data;
  Map<String, List<NotificationDataEntity>> groupedNotifications = {};
  List<String> sortedKeys = [];
  int count = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void fetchNotifications() async {
    setState(() {
      isLoading = true;
    });
    NotificationEntity? notificationData = await ref
        .read(notificationControllerProvider)
        .fetchNotifications(context);
    data = notificationData?.data;

    if (data != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      for (var notification in data!) {
        final createdAt = notification.createdAt!;
        String key;

        if (createdAt.isAfter(today)) {
          key = 'Today';
        } else if (createdAt.isAfter(yesterday)) {
          key = 'Yesterday';
        } else {
          key = DateFormat('dd MMM, yyyy').format(createdAt);
        }

        if (!groupedNotifications.containsKey(key)) {
          groupedNotifications[key] = [];
        }
        groupedNotifications[key]!.add(notification);
      }
    }

    sortedKeys = groupedNotifications.keys.toList();
    sortedKeys.sort((a, b) {
      if (a == 'Today') return -1;
      if (b == 'Today') return 1;
      if (a == 'Yesterday') return -1;
      if (b == 'Yesterday') return 1;
      return DateFormat('dd MMM, yyyy')
          .parse(b)
          .compareTo(DateFormat('dd MMM, yyyy').parse(a));
    });

    setState(() {
      count = data!.length;
      isLoading = false;
    });
  }

  String calculateTimeAgo(DateTime createdAt) {
    final currentTime = DateTime.now();
    final duration = currentTime.difference(createdAt);
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else {
      final hoursAgo = duration.inHours;
      return '${hoursAgo}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: primaryColor),
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
          "Notification",
          style: TextStyle(
              fontFamily: InterFontFamily.semiBold,
              fontSize: 18.sp,
              color: const Color(0xFF20043C)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 20.w),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10.w, vertical: 6.h),
                child: Text(
                  "$count New",
                  style: TextStyle(
                    fontFamily: InterFontFamily.medium,
                    fontSize: 12.sp,
                    color: customWhiteColor,
                  ),
                ),
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            children: isLoading
                ? [
                    const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  ]
                : data == null || data!.isEmpty
                    ? [
                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: 40.h),
                              SvgPicture.asset(
                                "assets/images/nodata.svg",
                              ),
                              Text(
                                "No Notifications",
                                style: TextStyle(
                                  fontFamily: InterFontFamily.semiBold,
                                  fontSize: 20.sp,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    : sortedKeys.map((dateKey) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonHeadTextWidget(day: dateKey),
                            SizedBox(height: 20.h),
                            ...groupedNotifications[dateKey]!
                                .reversed
                                .map((notification) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: NotificationWidget(
                                  notificationUrl: notification.image ?? "",
                                  title: notification.title ?? "Loading...",
                                  hoursAgo:
                                      calculateTimeAgo(notification.createdAt!),
                                  description:
                                      notification.description ?? "Loading...",
                                ),
                              );
                            }),
                            SizedBox(height: 20.h),
                          ],
                        );
                      }).toList(),
          ),
        ),
      ),
    );
  }
}
