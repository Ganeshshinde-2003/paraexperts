// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/core/resources/api_urls.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/utils/show_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:paraexpert/features/booked_packages/models/all_packages.dart';
import 'package:paraexpert/features/booked_packages/models/package_details_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getPackagesRepositoryProvider =
    Provider((ref) => GetPackagesRepository());

class GetPackagesRepository {
  Future<GetAllPackageResponse?> getAllPackages(
      BuildContext context, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');

      Map<String, String> query = {"status": status};

      final uri = Uri.parse("$apiBaseUrl$getAllPackagesBooked")
          .replace(queryParameters: query);
      final response = await http.get(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        GetAllPackageResponse allPackageResponse =
            GetAllPackageResponse.fromJson(responseBody);
        return allPackageResponse;
      } else {
        showSnackBar(context: context, content: "Failed to get appointments");
        return null;
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to get appointments");
      return null;
    }
  }

  Future<PackageBookedResponseModel?> getPackageById(
    BuildContext context,
    String packageId,
    String bookingId,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');

      Map<String, String> query = {
        "packageId": packageId,
        "bookingId": bookingId
      };

      final uri = Uri.parse("$apiBaseUrl$getPackageBookedById")
          .replace(queryParameters: query);

      final response = await http.get(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        return PackageBookedResponseModel.fromJson(json.decode(response.body));
      } else {
        showSnackBar(
            context: context, content: "Failed to get appointment details");
        return null;
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to get appointments");
      return null;
    }
  }

  Future<void> updatePackageStatus(
      BuildContext context, String status, String bookingId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      Map<String, String> query = {
        "status": status,
      };

      final uri =
          Uri.parse("$apiBaseUrl$updatePackageStatusToConfirm$bookingId")
              .replace(queryParameters: query);

      final response = await http.put(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.bottomBar, (route) => false);
        showSnackBar(
            context: context,
            content: "Package ${status.toUpperCase()} successfully");
      } else {
        showSnackBar(
            context: context,
            content: "Failed to ${status.toUpperCase()} package");
      }
    } catch (e) {
      showSnackBar(
          context: context,
          content: "Failed to ${status.toUpperCase()} package");
    }
  }
}
