import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraexpert/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository, ref);
});

class AuthController {
  final AuthRepository _authRepository;
  final ProviderRef ref;
  AuthController(this._authRepository, this.ref);

  Future<void> loginWithPhone({
    required String phoneNo,
    required BuildContext context,
  }) async {
    await _authRepository.loginWithPhone(
      phoneNo: phoneNo,
      context: context,
    );
  }

  Future<void> verifyOtp({
    required String otp,
    required String requestId,
    required BuildContext context,
  }) async {
    await _authRepository.verifyOtp(
      otp: otp,
      requestId: requestId,
      context: context,
    );
  }

  Future<void> updateParaProfile(
      BuildContext context, Map<String, dynamic> data) async {
    await _authRepository.updateProfileData(context, data);
  }
}
