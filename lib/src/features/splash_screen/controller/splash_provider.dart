import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/hive_storage.dart';
import '../../../core/router/app_routes.dart';

typedef SplashScreenNotifier = AutoDisposeAsyncNotifierProviderFamily<SplashScreenProvider, void, BuildContext>;

final splashScreenProvider = SplashScreenNotifier(SplashScreenProvider.new);

class SplashScreenProvider extends AutoDisposeFamilyAsyncNotifier<void , BuildContext> {

  @override
  FutureOr<void> build(BuildContext arg) async {
    Future.delayed(const Duration(milliseconds: 3500)).then((_) async {

      final store = ref.read(cacheServiceProvider);
      final isLoggedIn = await store.isLoggedIn;
      final userId = await store.userId;

      if (!arg.mounted) return; // Ensure the widget is still mounted before navigating

      if (isLoggedIn) {
        arg.go(AppRoutes.searchRoute,extra: {'tab': 0, 'userId': userId},);
      } else {
        arg.go(AppRoutes.loginRoute);
      }
    });

  }
}