// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paraexpert/core/resources/api_urls.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:paraexpert/core/utils/shared_pref.dart';
import 'package:paraexpert/core/utils/show_snack_bar.dart';
import 'package:paraexpert/features/auth/models/otp_response_model.dart';
import 'package:paraexpert/features/auth/models/phone_otp_model.dart';
import 'package:paraexpert/features/auth/models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

class AuthRepository {
  Future<void> loginWithPhone({
    required BuildContext context,
    required String phoneNo,
  }) async {
    try {
      const secureStorage = FlutterSecureStorage();
      String? fcmToken = await secureStorage.read(key: "fcmToken");
      Map<String, dynamic> body = {
        "phone": int.parse(phoneNo),
        "fcmToken": fcmToken,
      };

      final uri = Uri.parse("$apiBaseUrl$authPhoneUrl");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        MobileResponse mobileResponse = MobileResponse.fromJson(responseBody);

        Navigator.pushNamed(
          context,
          AppRoutes.verifyOtp,
          arguments: {
            'userPhone': phoneNo,
            'requestId': mobileResponse.data.requestId,
          },
        );
      } else {
        showSnackBar(context: context, content: "Failed to send OTP");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to send OTP");
    }
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String otp,
    required String requestId,
  }) async {
    try {
      Map<String, dynamic> body = {"requestId": requestId, "otp": otp};

      final uri = Uri.parse("$apiBaseUrl$verifyOtpUrl");
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        OTPResponse otpResponse = OTPResponse.fromJson(responseBody);

        if (otpResponse.success) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', otpResponse.data.token);
          await prefs.setBool('isNewUser', otpResponse.data.isNewUser);
          await prefs.setString('userId', otpResponse.data.userId);

          await fetchProfileData(context);

          Navigator.pushNamed(
            context,
            AppRoutes.bottomBar,
          );
        } else {
          showSnackBar(context: context, content: "Failed to verify OTP");
        }
      } else {
        showSnackBar(context: context, content: "Failed to send OTP");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to verify OTP");
    }
  }

  Future<void> updateProfileData(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');

      final uri = Uri.parse("$apiBaseUrl$updateProfileDataURL");

      final response = await http.patch(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        fetchProfileData(context);
        Navigator.pushNamed(context, AppRoutes.bottomBar);
        showSnackBar(context: context, content: "User Data Updated");
      } else {
        showSnackBar(context: context, content: "Failed to update User Data");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> fetchProfileData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      StoreInLocal storeInLocal = StoreInLocal();

      final uri = Uri.parse("$apiBaseUrl$userDataURL");

      final response = await http.get(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        UserResponseModel userResponse =
            UserResponseModel.fromJson(responseBody);

        await storeInLocal.saveUserResponse(userResponse);
      } else {
        showSnackBar(context: context, content: "Failed to fetch User Data");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Not a valid User");
    }
  }
}
