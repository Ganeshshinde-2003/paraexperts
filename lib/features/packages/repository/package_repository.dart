// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/core/resources/api_urls.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/utils/show_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:paraexpert/features/packages/models/all_packages_model.dart';
import 'package:paraexpert/features/packages/models/package_by_id_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final packageRepositoryProvider = Provider((ref) => PackageRepository());

class PackageRepository {
  Future<PackageResponse?> fetchPackages(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      final uri = Uri.parse("$apiBaseUrl$getAllPackageURL");

      final response = await http.get(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return PackageResponse.fromJson(responseBody);
      } else {
        showSnackBar(context: context, content: "Failed to get packages");
      }

      return null;
    } catch (e) {
      showSnackBar(context: context, content: "Failed to get packages");
      return null;
    }
  }

  Future<void> createPackage(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      final uri = Uri.parse("$apiBaseUrl$createPackageURL");

      final response = await http.post(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        showSnackBar(context: context, content: "Package created successfully");
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.packages,
          (route) => false,
        );
      } else {
        showSnackBar(context: context, content: "Failed to create package");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to create package");
    }
  }

  Future<PackageByIdResponse?> fetchPackagesById(
      BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      final uri = Uri.parse("$apiBaseUrl$getAllPackageURL/$id");

      final response = await http.get(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return PackageByIdResponse.fromJson(responseBody);
      } else {
        showSnackBar(context: context, content: "Failed to get packages");
      }

      return null;
    } catch (e) {
      showSnackBar(context: context, content: "Failed to get packages");
      return null;
    }
  }

  Future<void> updatePackageById(
      BuildContext context, String id, Map<String, dynamic> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      final uri = Uri.parse("$apiBaseUrl$getAllPackageURL/$id");

      final response = await http.patch(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        showSnackBar(context: context, content: "Package updated successfully");
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.packages,
          (route) => false,
        );
      } else {
        showSnackBar(context: context, content: "Failed to update package");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to update packages");
    }
  }

  Future<void> deletePackageById(BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      final uri = Uri.parse("$apiBaseUrl$deletePackageURL$id");

      final response = await http.delete(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        showSnackBar(context: context, content: "Package deleted successfully");
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.packages,
          (route) => false,
        );
      } else {
        showSnackBar(context: context, content: "Failed to delete package");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to delete packages");
    }
  }
}
