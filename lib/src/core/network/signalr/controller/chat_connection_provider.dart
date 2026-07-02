import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/hub_connection.dart';

import '../../../database/hive_storage.dart';
import '../repository/chat_hub_repository.dart';

final chatConnectionProvider =
AsyncNotifierProvider<ChatConnectionNotifier, HubConnectionState>(
    ChatConnectionNotifier.new);

class ChatConnectionNotifier extends AsyncNotifier<HubConnectionState> {
  @override
  Future<HubConnectionState> build() async {
    final isLoggedIn = await ref.watch(isLoggedInProvider.future);
    final service = ref.read(chatHubServiceProvider);

    if (isLoggedIn) {
      await service.connect();
      ref.onDispose(() => service.disconnect());
      return HubConnectionState.Connected;
    }
    return HubConnectionState.Disconnected;
  }

}