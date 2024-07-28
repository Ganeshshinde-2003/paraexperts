import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/features/available_slots/models/get_available_slots_model.dart';
import 'package:paraexpert/features/available_slots/repository/available_slots_repository.dart';

final availableSlotsControllerProvider = Provider((ref) {
  final availabbleSlotsRepository = ref.watch(availableSlotsRepositoryProvider);
  return AvailableSlotsController(availabbleSlotsRepository);
});

class AvailableSlotsController {
  final AvailableSlotsRepository _availableSlotsRepository;

  AvailableSlotsController(this._availableSlotsRepository);

  Future<void> setAvailableSlots(
    BuildContext context,
    List<Map<String, dynamic>> slots,
  ) async {
    await _availableSlotsRepository.setAvailableSlots(context, slots);
  }

  Future<AvailabilityResponse?> getAvailableSlots(BuildContext context) async {
    return await _availableSlotsRepository.getAvailableSlots(context);
  }
}
