import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/database/hive_storage.dart';
import 'package:next_talk/src/core/router/app_routes.dart';
import '../../../core/network/signalr/controller/chat_connection_provider.dart';
import '../../../core/network/signalr/repository/chat_hub_repository.dart';

typedef ProfileControllerNotifier =
AutoDisposeAsyncNotifierProvider<ProfileProvider, void>;

final profileProvider = ProfileControllerNotifier(ProfileProvider.new);

class ProfileProvider extends AutoDisposeAsyncNotifier {

  @override
  FutureOr<void> build() async {

  }

  Future<void> logout(BuildContext context) async {
    // 1. Disconnect the live socket FIRST, before touching anything else —
    //    this is the step that was completely missing.
    final chatService = ref.read(chatHubServiceProvider);
    try {
      await chatService.disconnect();
      log("chatService disconnected");
    } catch (e) {
      log("Error login out : $e");
    }

    // 2. Clear persisted auth state
    final cacheService = ref.read(cacheServiceProvider);
    await cacheService.clearAuthTokens();

    // 3. Invalidate every provider that holds session-scoped state, so the
    //    next login rebuilds them fresh instead of reusing stale instances.
    ref.invalidate(chatConnectionProvider);
    ref.invalidate(chatHubServiceProvider);
    ref.invalidate(isLoggedInProvider);

    if (!context.mounted) return;

    context.push(AppRoutes.splashScreenRoute);
  }


}
