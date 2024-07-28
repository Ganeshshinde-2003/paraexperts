import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/auth/controller/auth_controller.dart';
import 'package:paraexpert/features/onboarding/widgets/subtitle_text.dart';
import 'package:paraexpert/features/onboarding/widgets/title_head.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  String countryCode = '+91';
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _verifyPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      await ref.read(authControllerProvider).loginWithPhone(
            phoneNo: phoneController.text,
            context: context,
          );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(25.w, 30.h, 25.w, 40.h),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OnBoardingTitle(
                          title: "Get Your Mindfulness",
                          align: TextAlign.start,
                          color: primaryColor,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const OnBoardingSubtitleTitle(
                          title:
                              "Login to begin our customized mindfulness\njourney together.",
                          align: TextAlign.start,
                          color: primaryColor,
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        IntlPhoneField(
                          autofocus: true,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: InterFontFamily.semiBold,
                            color: tertiaryColor,
                          ),
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
                            filled: true,
                          ),
                          initialCountryCode: 'IN',
                          controller: phoneController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (phone) {
                            setState(() {
                              countryCode = phone.countryCode;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.number.isEmpty) {
                              return 'Please enter a mobile number';
                            } else if (value.number.length != 10) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _verifyPhoneNumber,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: 45.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: secondaryColor,
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
      ),
    );
  }
}
