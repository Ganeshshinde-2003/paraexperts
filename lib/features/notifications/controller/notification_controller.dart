import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/features/notifications/models/notification_model.dart';
import 'package:paraexpert/features/notifications/repository/notification_repository.dart';

final notificationControllerProvider = Provider((ref) {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return NotificationController(notificationRepository);
});

class NotificationController {
  final NotificationRepository _notificationRepository;

  NotificationController(this._notificationRepository);

  Future<NotificationEntity?> fetchNotifications(BuildContext context) async {
    return await _notificationRepository.fetchNotifications(context);
  }
}
