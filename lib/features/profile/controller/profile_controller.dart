import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/features/profile/models/profile_upload_model.dart';
import 'package:paraexpert/features/profile/repository/profile_repository.dart';

final profileControllerProvider = Provider((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileController(profileRepository);
});

class ProfileController {
  final ProfileRepository _profileRepository;

  ProfileController(this._profileRepository);

  Future<UserProfilePictureUploadModel?> uploadProfileImage(
      BuildContext context, File? image) async {
    return await _profileRepository.uploadProfileImage(context, image);
  }

  Future<UserProfilePictureUploadModel?> uploadQualificationImage(
      BuildContext context, File? image) async {
    return await _profileRepository.uploadQualificationImage(context, image);
  }
}
