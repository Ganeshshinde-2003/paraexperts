import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/features/booked_packages/models/all_packages.dart';
import 'package:paraexpert/features/booked_packages/models/package_details_mode.dart';
import 'package:paraexpert/features/booked_packages/respository/package_repository.dart';

final getPackagesControllerProvider = Provider((ref) {
  final packagesRepository = ref.watch(getPackagesRepositoryProvider);
  return GetPackagesController(packagesRepository);
});

class GetPackagesController {
  final GetPackagesRepository _packagesRepository;

  GetPackagesController(this._packagesRepository);

  Future<GetAllPackageResponse?> getAllPackages(
      BuildContext context, String status) async {
    return await _packagesRepository.getAllPackages(context, status);
  }

  Future<PackageBookedResponseModel?> getPackageById(
    BuildContext context,
    String packageId,
    String bookingId,
  ) async {
    return await _packagesRepository.getPackageById(
        context, packageId, bookingId);
  }

  Future<void> updatePackageStatus(
      BuildContext context, String status, String bookingId) async {
    return await _packagesRepository.updatePackageStatus(
        context, status, bookingId);
  }
}
