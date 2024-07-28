import 'dart:convert';

import 'package:paraexpert/features/auth/models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreInLocal {
  Future<void> saveUserResponse(UserResponseModel userResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userResponseJson = jsonEncode(userResponse.toJson());
    await prefs.setString('userResponse', userResponseJson);
  }

  Future<UserResponseModel?> getUserResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userResponseJson = prefs.getString('userResponse');
    if (userResponseJson != null) {
      Map<String, dynamic> userResponseMap = jsonDecode(userResponseJson);
      return UserResponseModel.fromJson(userResponseMap);
    }
    return null;
  }
}
