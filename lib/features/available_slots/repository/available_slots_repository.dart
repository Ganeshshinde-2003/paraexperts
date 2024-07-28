// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/core/resources/api_urls.dart';
import 'package:paraexpert/core/utils/show_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:paraexpert/features/available_slots/models/get_available_slots_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final availableSlotsRepositoryProvider =
    Provider((ref) => AvailableSlotsRepository());

class AvailableSlotsRepository {
  Future<void> setAvailableSlots(
    BuildContext context,
    List<Map<String, dynamic>> slots,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      Map<String, dynamic> body = {
        "availability": slots,
      };
      final uri = Uri.parse("$apiBaseUrl$setAvailableSlotURL");

      final response = await http.patch(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        showSnackBar(
            context: context, content: "Available slots set successfully");
      } else {
        showSnackBar(context: context, content: "Faild to set available slots");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Faild to set available slots");
    }
  }

  Future<AvailabilityResponse?> getAvailableSlots(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');

      final uri = Uri.parse("$apiBaseUrl$getAvailableSlotURL");

      final response = await http.get(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final AvailabilityResponse availabilityResponse =
            AvailabilityResponse.fromJson(jsonDecode(response.body));
        return availabilityResponse;
      }

      return null;
    } catch (e) {
      showSnackBar(context: context, content: "Faild to get available slots");
      return null;
    }
  }
}
