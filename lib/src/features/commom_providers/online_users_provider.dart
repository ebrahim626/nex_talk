import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/signalr/repository/chat_hub_repository.dart';

final onlineUsersProvider = NotifierProvider<OnlineUsersNotifier, Set<String>>(
  OnlineUsersNotifier.new,
);

class OnlineUsersNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final chatService = ref.read(chatHubServiceProvider);

    final onlineSub = chatService.onUserOnline.listen((userId) {
      log("ONLINE: $userId");
      state = {...state, userId};
    });

    final offlineSub = chatService.onUserOffline.listen((userId) {
      log("OFFLINE: $userId");
      state = {...state}..remove(userId);
    });

    final onlineUsersSub = chatService.onOnlineUsers.listen((users) {
      state = users.toSet();
    });

    ref.onDispose(() {
      onlineSub.cancel();
      offlineSub.cancel();
      onlineUsersSub.cancel();
    });

    return {};
  }

  bool isOnline(String userId) => state.contains(userId);
}