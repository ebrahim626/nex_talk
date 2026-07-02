import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/hive_storage.dart';
import '../../../core/network/signalr/controller/chat_connection_provider.dart';
import '../../../core/router/app_routes.dart';

typedef SplashScreenNotifier = AutoDisposeAsyncNotifierProviderFamily<SplashScreenProvider, void, BuildContext>;

final splashScreenProvider = SplashScreenNotifier(SplashScreenProvider.new);

class SplashScreenProvider extends AutoDisposeFamilyAsyncNotifier<void, BuildContext> {

  @override
  FutureOr<void> build(BuildContext arg) async {
    // Show splash screen for 2.5 seconds
    // await Future.delayed(const Duration(milliseconds: 2500));

    final store = ref.read(cacheServiceProvider);
    final isLoggedIn = await store.isLoggedIn;
    final userId = await store.userId;

    if (!arg.mounted) return;

    if (isLoggedIn && userId != null && userId.isNotEmpty) {
      try {
        // Initialize and wait for connection
        await ref.read(chatConnectionProvider.future);
        if (!arg.mounted) return;
        log("[SplashScreen] SignalR connected! Navigating to home...");
        arg.go(
          AppRoutes.searchRoute,
          extra: {'tab': 0, 'userId': userId},
        );
      } catch (e) {
        log("[SplashScreen] Connection error: $e");
        if (!arg.mounted) return;
        arg.go(
          AppRoutes.searchRoute,
          extra: {'tab': 0, 'userId': userId},
        );
      }
    } else {
      log("[SplashScreen] User not logged in. Navigating to login...");
      arg.go(AppRoutes.loginRoute);
    }
  }
}