import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/features/appointment/models/appoinment_details_model.dart';
import 'package:paraexpert/features/appointment/models/appoinments_model.dart';
import 'package:paraexpert/features/appointment/repository/all_appointment.dart';

final getAppointmentsControllerProvider = Provider((ref) {
  final appointmentsRepository = ref.watch(getAppointmentsRepositoryProvider);
  return GetAppointmentController(appointmentsRepository, ref);
});

class GetAppointmentController {
  final GetAppointmentsRepository _appointmentsRepository;
  final ProviderRef ref;

  GetAppointmentController(this._appointmentsRepository, this.ref);

  Future<AppointmentResponse> getAllAppointments(
      BuildContext context, String status) async {
    return await _appointmentsRepository.getAllAppointments(context, status);
  }

  Future<AppointmentDetailModel?> getAppointmentByID(
      BuildContext context, String bookingID) async {
    return await _appointmentsRepository.getAppointmentByID(context, bookingID);
  }
}
