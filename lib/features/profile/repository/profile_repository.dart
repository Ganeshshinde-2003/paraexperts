// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/core/resources/api_urls.dart';
import 'package:paraexpert/core/utils/show_snack_bar.dart';
import 'package:paraexpert/features/profile/models/profile_upload_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final profileRepositoryProvider = Provider((ref) => ProfileRepository());

class ProfileRepository {
  Future<UserProfilePictureUploadModel?> uploadProfileImage(
      BuildContext context, File? image) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      final uri = Uri.parse("$apiBaseUrl$updateUserProfilePictureUrl/$userId");

      var request = http.MultipartRequest('POST', uri)
        ..files.add(
            await http.MultipartFile.fromPath('profilePicture', image!.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return UserProfilePictureUploadModel.fromJson(responseBody);
      } else {
        showSnackBar(context: context, content: "Failed to upload image");
        return null;
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to upload image");
      return null;
    }
  }

  Future<UserProfilePictureUploadModel?> uploadQualificationImage(
      BuildContext context, File? image) async {
    try {
      final uri = Uri.parse("$apiBaseUrl$uploadQualificationImageURL");

      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
            'uploadCertificate', image!.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return UserProfilePictureUploadModel.fromJson(responseBody);
      } else {
        showSnackBar(context: context, content: "Failed to upload image");
        return null;
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to upload image");
      return null;
    }
  }
}
