import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/database/hive_storage.dart';
import 'package:next_talk/src/core/router/app_routes.dart';
import 'package:next_talk/src/features/auth/login_section/auth_model/request/auth_request_model.dart';
import 'package:next_talk/src/features/auth/login_section/auth_model/response/auth_response_model.dart';
import 'package:next_talk/src/features/auth/login_section/repository/auth_repository.dart';
import 'package:next_talk/src/shared/toast/toast.dart';
import '../../../../core/network/signalr/controller/chat_connection_provider.dart';

typedef LoginProviderNotifier =
    AutoDisposeAsyncNotifierProvider<LoginProvider, void>;

final loginProvider = LoginProviderNotifier(LoginProvider.new);

class LoginProvider extends AutoDisposeAsyncNotifier<void> {

  //Register controller
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerUserNameController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();

  //Sign-in controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthResponseModel? userInfo;

  //  Getters for register
  String get email => registerEmailController.text.trim();
  String get userName => registerUserNameController.text.trim();
  String get password => registerPasswordController.text;

  //  Getters for login
  String get loginEmail => emailController.text.trim();
  String get loginPassword => passwordController.text;

  @override
  FutureOr<void> build() {

  }

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

  // bool _validateAll() {
  //   final emailErr = validateEmail(email);
  //   final userErr = validateUserName(userName);
  //   final passErr = validatePassword(password);
  //
  //   if (emailErr != null) {
  //     log('[LoginProvider] Email error: $emailErr');
  //     return false;
  //   }
  //   if (userErr != null) {
  //     log('[LoginProvider] Username error: $userErr');
  //     return false;
  //   }
  //   if (passErr != null) {
  //     log('[LoginProvider] Password error: $passErr');
  //     return false;
  //   }
  //   return true;
  // }

  // ── Register ──────────────────────────────────────────────────────────────
  Future<void> authRegister(BuildContext context,GlobalKey<FormState> formKey) async {
    try {
      EasyLoading.show();
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
        userInfo = AuthResponseModel.fromJson(response.data);
        log("Bearer token : ${userInfo?.token}");
        final store = ref.read(cacheServiceProvider);
        store.setLoggedIn(true);
        store.setUserId(userInfo?.userId ?? "");
        store.setUserName(userInfo?.username ?? "");
        log("Stored user id : ${userInfo?.userId}");
        store.setBearerToken(userInfo?.token ?? "");
        ref.invalidate(isLoggedInProvider);

        // 👈 establish the socket connection BEFORE navigating in
        try {
          await ref.read(chatConnectionProvider.future);
          log("[LoginProvider] SignalR connected after register");
        } catch (e) {
          log("[LoginProvider] SignalR connect failed after register: $e");
          // don't block navigation on this — chat features will
          // surface their own error state if the socket never connects
        }

        if (!context.mounted) return;
        context.go(
          AppRoutes.searchRoute,
          extra: {'tab': 0, 'userId': userInfo?.userId},
        );
      } else {
        log("error creating account ${response.data}");
        FlashCard.showError(
          errorMessage: "Failed create account : ${response.data["message"]}",
        );
      }
    } catch (e) {
      log("Error creating account : $e");
    }
    finally{
      EasyLoading.dismiss();
    }
  }

  Future<void> logIn(BuildContext context,GlobalKey<FormState> formKey) async {
    try {
      EasyLoading.show();
      if (!formKey.currentState!.validate()) {
        return;
      }
      log('[LoginProvider] Registering: $email / $userName');
      final loginRequestModel = AuthRequestModel(
        password: loginPassword,
        email: loginEmail,
      );
      final repo = ref.read(authRepository);
      final response = await repo.login(loginRequestModel);
      if (response.statusCode == 200 || response.statusCode == 201) {
        FlashCard.showSuccess(message: "Login Successfully");
        userInfo = AuthResponseModel.fromJson(response.data);
        log("Bearer token : ${userInfo?.token}");
        if(userInfo!.token.isNotEmpty) {
          final store = ref.read(cacheServiceProvider);
          store.refreshToken;
          store.setLoggedIn(true);
          store.setUserId(userInfo?.userId ?? "");
          store.setUserName(userInfo?.username ?? "");
          log("Stored user id : ${userInfo?.userId}");
          store.setBearerToken(userInfo?.token ?? "");
          ref.invalidate(isLoggedInProvider);

          // 👈 establish the socket connection BEFORE navigating in
          try {
            await ref.read(chatConnectionProvider.future);
            log("[LoginProvider] SignalR connected after register");
          } catch (e) {
            log("[LoginProvider] SignalR connect failed after register: $e");
            // don't block navigation on this — chat features will
            // surface their own error state if the socket never connects
          }

          if (!context.mounted) return;
          context.go(
            AppRoutes.searchRoute,
            extra: {'tab': 0, 'userId': userInfo?.userId},
          );
        }
      } else {
        log("error logging ${response.data}");
        FlashCard.showError(
          errorMessage: "Failed login : ${response.data["message"]}",
        );
      }
    } catch (e) {
      log("Error creating account : $e");
    }
    finally{
      EasyLoading.dismiss();
    }
  }

}
