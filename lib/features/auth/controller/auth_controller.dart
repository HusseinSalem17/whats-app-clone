// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/features/auth/repository/auth_repo.dart';

import '../../../models/user_model.dart';

final authControllerProvider = Provider(
  (ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    //provider.of<AuthRepo>(context);
    return AuthController(
      authRepo: authRepo,
      ref: ref,
    );
  },
);

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepo;
  final ProviderRef ref;
  AuthController({
    required this.authRepo,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepo.getCurrentUserData();
    return user;
  }

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

  void saveUserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    authRepo.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }
}
