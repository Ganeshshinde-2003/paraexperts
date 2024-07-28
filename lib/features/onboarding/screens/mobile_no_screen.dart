// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/features/onboarding/widgets/subtitle_text.dart';
import 'package:paraexpert/features/onboarding/widgets/title_head.dart';

class MobileNoScreen extends StatefulWidget {
  const MobileNoScreen({super.key});

  @override
  State<MobileNoScreen> createState() => _Screen3State();
}

class _Screen3State extends State<MobileNoScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: primaryColor),
          backgroundColor: secondaryColor,
          leading: IconButton(
            padding: EdgeInsetsDirectional.only(start: 20.w),
            onPressed: () {
              exit(0);
            },
            icon: SvgPicture.asset(
              "assets/icons/back_button.svg",
            ),
          ),
        ),
        backgroundColor: secondaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: 60.h, bottom: 60.h),
              child: SizedBox(
                child: SvgPicture.asset("assets/images/screen4Main.svg"),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        "assets/images/bgCirclePurple.svg",
                        fit: BoxFit.cover,
                      )),
                  Center(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          25.w, 80.h, 25.w, 10.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const OnBoardingTitle(
                                  title: "Get Your Mindfulness",
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                const OnBoardingSubtitleTitle(
                                  title:
                                      "Login to begin our customized mindfulness\njourney together.",
                                  align: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                IntlPhoneField(
                                  decoration: InputDecoration(
                                      counterText: "",
                                      hintText: 'Enter Mobile Number',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      fillColor: secondaryColor,
                                      filled: true),
                                  showCursor: false,
                                  initialCountryCode: 'IN',
                                  readOnly: true,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.auth,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.33,
                              height: 4.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.r),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
