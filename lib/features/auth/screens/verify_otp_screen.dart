import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/auth/controller/auth_controller.dart';
import 'package:paraexpert/features/onboarding/widgets/subtitle_text.dart';
import 'package:paraexpert/features/onboarding/widgets/title_head.dart';
import 'package:pinput/pinput.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  final String userPhone;
  final String requestId;
  const VerifyOTPScreen({
    super.key,
    required this.userPhone,
    required this.requestId,
  });

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends ConsumerState<VerifyOTPScreen> {
  String otp = "";
  bool isLoading = false;

  void _verifyOTP() async {
    if (otp.length == 6) {
      setState(() {
        isLoading = true;
      });

      await ref.read(authControllerProvider).verifyOtp(
            otp: otp,
            requestId: widget.requestId,
            context: context,
          );

      setState(() {
        isLoading = false;
      });
    }
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
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(25.w, 10.h, 25.w, 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const OnBoardingTitle(
                        title: "OTP Verification",
                        align: TextAlign.start,
                        color: primaryColor,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      OnBoardingSubtitleTitle(
                        title:
                            "Enter the verification code we just sent on\n+91 *******${widget.userPhone[7]}${widget.userPhone[8]}${widget.userPhone[9]}",
                        align: TextAlign.start,
                        color: primaryColor,
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Pinput(
                          length: 6,
                          defaultPinTheme: PinTheme(
                            width: 45.w,
                            height: 50.h,
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: primaryColor,
                              fontFamily: URWGothicFontFamily.demi,
                            ),
                            decoration: BoxDecoration(
                              color: otpPinBgColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor,
                              ),
                            ),
                          ),
                          showCursor: false,
                          onChanged: (value) {
                            otp = value;
                          },
                        ),
                      ),
                      SizedBox(height: 40.h),
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          "Didn't receive OTP?",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: primaryColor,
                            fontFamily: InterFontFamily.regular,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Resend code",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: onSecondaryTextColor,
                              fontFamily: InterFontFamily.regular,
                              decoration: TextDecoration.underline,
                              decorationColor: primaryColor,
                              decorationThickness: 2.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _verifyOTP,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.r),
                      ),
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Verify",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: onPrimaryTextColor,
                                fontFamily: InterFontFamily.semiBold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
