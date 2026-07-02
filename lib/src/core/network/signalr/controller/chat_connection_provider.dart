import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/hive_storage.dart';
import '../repository/chat_hub_repository.dart';

final chatConnectionProvider = AsyncNotifierProvider<ChatConnectionNotifier, void>(
  ChatConnectionNotifier.new,
);

class ChatConnectionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {
    final cacheService = ref.watch(cacheServiceProvider);
    final userId = await cacheService.userId;

    if (userId != null && userId.isNotEmpty) {
      try {
        final chatService = ref.read(chatHubServiceProvider);
        await chatService.connect();
      } catch (e) {
        log('[ChatConnectionNotifier] Connection failed: ❌ $e');
        rethrow;
      }
    }
  }
}