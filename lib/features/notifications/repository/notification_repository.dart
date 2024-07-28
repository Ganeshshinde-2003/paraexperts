// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/core/resources/api_urls.dart';
import 'package:paraexpert/core/utils/show_snack_bar.dart';
import 'package:paraexpert/features/notifications/models/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final notificationRepositoryProvider =
    Provider((ref) => NotificationRepository());

class NotificationRepository {
  Future<NotificationEntity?> fetchNotifications(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      final uri = Uri.parse("$apiBaseUrl$getNotificationsUrl");

      final response = await http.get(uri, headers: {
        "authorization": authToken!,
        "Content-Type": "application/json"
      });

      if (response.statusCode == 200) {
        return NotificationEntity.fromJson(json.decode(response.body));
      } else {
        showSnackBar(context: context, content: "Faild to fetch notifications");
      }

      return null;
    } catch (e) {
      showSnackBar(context: context, content: "Faild to fetch notifications");
      return null;
    }
  }
}
