import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/features/packages/models/all_packages_model.dart';
import 'package:paraexpert/features/packages/models/package_by_id_model.dart';
import 'package:paraexpert/features/packages/repository/package_repository.dart';

final packagesControllerProvider = Provider((ref) {
  final packageRepository = ref.watch(packageRepositoryProvider);
  return PackagesController(packageRepository);
});

class PackagesController {
  final PackageRepository _packageRepository;

  PackagesController(this._packageRepository);

  Future<PackageResponse?> fetchPackages(BuildContext context) async {
    return await _packageRepository.fetchPackages(context);
  }

  Future<void> createPackage(
      BuildContext context, Map<String, dynamic> data) async {
    return await _packageRepository.createPackage(context, data);
  }

  Future<PackageByIdResponse?> getPackageById(
      BuildContext context, String id) async {
    return await _packageRepository.fetchPackagesById(context, id);
  }

  Future<void> updatePackage(
      BuildContext context, String id, Map<String, dynamic> data) async {
    return await _packageRepository.updatePackageById(context, id, data);
  }

  Future<void> deletePackage(BuildContext context, String id) async {
    return await _packageRepository.deletePackageById(context, id);
  }
}
