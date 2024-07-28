// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/resources/data.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/core/utils/on_will_pop_up.dart';
import 'package:paraexpert/core/utils/shared_pref.dart';
import 'package:paraexpert/features/auth/models/user_profile_model.dart';
import 'package:paraexpert/features/profile/widgets/common_column_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name = "";
  String? userProfile;
  UserResponseModel? userResponseModel;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('isNewUser');
    await prefs.remove('userResponse');

    Navigator.pushNamedAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      AppRoutes.mobileNoScreen,
      (route) => false,
    );
  }

  void fetchUserData() async {
    StoreInLocal storeInLocal = StoreInLocal();
    userResponseModel = await storeInLocal.getUserResponse();
    setState(() {
      name = userResponseModel!.data.userId.name;
      userProfile = userResponseModel!.data.userId.profilePicture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => ConfirmExitDialog.showExitConfirmationDialog(context),
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: primaryColor),
            backgroundColor: secondaryColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.bottomBar,
                  (route) => false,
                );
              },
              icon: SvgPicture.asset(
                "assets/icons/back_button.svg",
              ),
            ),
            title: Text(
              "Profile",
              style: TextStyle(
                fontFamily: InterFontFamily.semiBold,
                fontSize: 20.sp,
                color: const Color(0xFF20043C),
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                    child: ClipOval(
                      child: Image.network(
                        userProfile != "" && userProfile != null
                            ? userProfile.toString()
                            : AppData.userDefaultImage,
                        width: 100.w,
                        height: 100.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    name ?? "",
                    style: TextStyle(
                      fontFamily: InterFontFamily.bold,
                      fontSize: 20.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                    child: const CommonColumnWidget(
                      title: "Your Profile",
                      iconPath: "assets/icons/person.png",
                    ),
                  ),
                  // SizedBox(height: 10.h),
                  // InkWell(
                  //   onTap: () {},
                  //   child: const CommonColumnWidget(
                  //     title: "Settings",
                  //     iconPath: "assets/icons/settings.png",
                  //   ),
                  // ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.helpCenter);
                    },
                    child: const CommonColumnWidget(
                      title: "Help Center",
                      iconPath: "assets/icons/security.png",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                    },
                    child: const CommonColumnWidget(
                      title: "Privacy Policy",
                      iconPath: "assets/icons/privacy.png",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () => _showLogoutBottomSheet(context),
                    child: const CommonColumnWidget(
                      title: "Log out",
                      iconPath: "assets/icons/logout.png",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding:
              EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w, bottom: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.32,
                height: 5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.r),
                  ),
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 40.h),
              Image.asset(
                "assets/icons/logouticon.png",
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 30.h),
              Text(
                "Logout",
                style: TextStyle(
                  fontFamily: InterFontFamily.bold,
                  fontSize: 30.sp,
                  color: const Color(0xff1E232C),
                ),
              ),
              Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  fontFamily: InterFontFamily.regular,
                  fontSize: 16.sp,
                  color: const Color(0xff8391A1),
                ),
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: primaryColor,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancle',
                            style: TextStyle(
                              fontFamily: InterFontFamily.regular,
                              fontSize: 18.sp,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: logout,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: primaryColor,
                        border: Border.all(
                          color: primaryColor,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Yes, Logout',
                            style: TextStyle(
                              fontFamily: InterFontFamily.semiBold,
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
