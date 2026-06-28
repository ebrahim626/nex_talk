import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/core/database/hive_storage.dart';
import 'package:next_talk/src/features/auth/login_section/auth_model/request/auth_request_model.dart';
import 'package:next_talk/src/features/auth/login_section/auth_model/response/auth_response_model.dart';
import 'package:next_talk/src/features/auth/login_section/repository/auth_repository.dart';
import 'package:next_talk/src/shared/toast/toast.dart';

typedef LoginProviderNotifier =
    AutoDisposeAsyncNotifierProvider<LoginProvider, void>;

final loginProvider = LoginProviderNotifier(LoginProvider.new);

class LoginProvider extends AutoDisposeAsyncNotifier<void> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //  Getters
  String get email => emailController.text.trim();
  String get userName => userNameController.text.trim();
  String get password => passwordController.text;

  @override
  FutureOr<void> build() {}

  //  Validators
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w.+-]+@[a-zA-Z\d-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateUserName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // ── All-fields validation ─────────────────────────────────────────────────
  bool _validateAll() {
    final emailErr = validateEmail(email);
    final userErr = validateUserName(userName);
    final passErr = validatePassword(password);

    if (emailErr != null) {
      log('[LoginProvider] Email error: $emailErr');
      return false;
    }
    if (userErr != null) {
      log('[LoginProvider] Username error: $userErr');
      return false;
    }
    if (passErr != null) {
      log('[LoginProvider] Password error: $passErr');
      return false;
    }
    return true;
  }

  // ── Register ──────────────────────────────────────────────────────────────
  Future<void> authRegister() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      log('[LoginProvider] Registering: $email / $userName');
      final authRequestModel = AuthRequestModel(
        userName: userName,
        email: email,
        password: password,
      );
      final repo = ref.read(authRepository);
      final response = await repo.register(authRequestModel);
      if (response.statusCode == 200 || response.statusCode == 201) {
        FlashCard.showSuccess(message: "Account Created Successfully");
        AuthResponseModel userInfo = AuthResponseModel.fromJson(response.data);
        log("Bearer token : ${userInfo.token}");
        final store = ref.read(cacheServiceProvider);
        store.setLoggedIn(true);
        store.setBearerToken(userInfo.token);
        ref.invalidate(isLoggedInProvider);
      } else {
        log("error creating account ${response.data}");
        FlashCard.showError(
          errorMessage: "Failed create account : ${response.data["message"]}",
        );
      }
    } catch (e) {
      log("Error creating account : $e");
    }
  }
}
