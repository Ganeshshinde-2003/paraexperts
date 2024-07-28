import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashService _splashService = SplashService();

  @override
  void initState() {
    super.initState();
    _splashService.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              splashGradientColor.withOpacity(1.0),
              tertiaryColor.withOpacity(0.75),
              tertiaryColor.withOpacity(0.85),
              tertiaryColor.withOpacity(0.95),
              tertiaryColor,
              tertiaryColor.withOpacity(0.95),
              tertiaryColor.withOpacity(0.85),
              tertiaryColor.withOpacity(0.75),
              splashGradientColor.withOpacity(0.9),
            ],
            stops: const [0.0, 0.01, 0.1, 0.3, 0.5, 0.7, 0.9, 0.99, 1.0],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: SvgPicture.asset(
                          "assets/icons/logo_white.svg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        "ParaTalks",
                        style: TextStyle(
                            color: onPrimaryTextColor,
                            fontSize: 50.sp,
                            fontFamily: WallmanLoveFontFamily.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 4.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SplashService {
  void isLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('userId');

    Timer(const Duration(seconds: 2), () {
      if (token != null && userId != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.bottomBar);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.mobileNoScreen);
      }
    });
  }
}
