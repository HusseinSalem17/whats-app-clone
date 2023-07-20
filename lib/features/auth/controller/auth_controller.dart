// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repo.dart';

final authControllerProvider = Provider(
  (ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    //provider.of<AuthRepo>(context);
    return AuthController(authRepo: authRepo);
  },
);

class AuthController {
  final AuthRepository authRepo;
  AuthController({
    required this.authRepo,
  });

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepo.signInWithPhone(context: context, phoneNumber: phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepo.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }
}
