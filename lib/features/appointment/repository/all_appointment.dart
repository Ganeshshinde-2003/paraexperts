// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:paraexpert/core/resources/api_urls.dart';
import 'package:paraexpert/core/utils/show_snack_bar.dart';
import 'package:paraexpert/features/appointment/models/appoinment_details_model.dart';
import 'package:paraexpert/features/appointment/models/appoinments_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getAppointmentsRepositoryProvider =
    Provider((ref) => GetAppointmentsRepository());

class GetAppointmentsRepository {
  Future<AppointmentResponse> getAllAppointments(
      BuildContext context, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');

      Map<String, String> query = {"status": status};
      final uri = Uri.parse("$apiBaseUrl$allAppointmentsUrl")
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
        AppointmentResponse appointmentResponse =
            AppointmentResponse.fromJson(responseBody);
        return appointmentResponse;
      } else {
        showSnackBar(context: context, content: "Failed to get appointments");
        return AppointmentResponse(
          statusCode: 500,
          data: [],
          message: "Failed to get appointments",
          success: false,
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: "Failed to get appointments");
      return AppointmentResponse(
        statusCode: 500,
        data: [],
        message: "Failed to get appointments",
        success: false,
      );
    }
  }

  Future<AppointmentDetailModel?> getAppointmentByID(
    BuildContext context,
    String bookingID,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      final uri = Uri.parse("$apiBaseUrl$appointmenDetailByIDUrl/$bookingID");

      final response = await http.get(
        uri,
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        return AppointmentDetailModel.fromJson(json.decode(response.body));
      } else {
        showSnackBar(
            context: context, content: "Failed to get appointment details");
      }

      return null;
    } catch (e) {
      showSnackBar(
          context: context, content: "Failed to get appointment details");
      return null;
    }
  }
}
