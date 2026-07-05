import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_summary_model/response/group_summary_model.dart';
import 'package:next_talk/src/features/home_section/chat_section/repository/all_chat_repository.dart';
import 'package:next_talk/src/shared/toast/toast.dart';
import '../../../../core/network/signalr/repository/chat_hub_repository.dart';
import '../chat_summary_model/response/chat_summary_model.dart';
import '../view/components/current_user_id_provider.dart';

typedef AllGroupChatsProviderNotifier =
AutoDisposeAsyncNotifierProviderFamily<AllGroupChatsProvider, List<dynamic>, String>;

final allGroupChatsProvider = AllGroupChatsProviderNotifier(AllGroupChatsProvider.new);

class AllGroupChatsProvider extends AutoDisposeFamilyAsyncNotifier<List<dynamic>, String> {

  @override
  FutureOr<List<dynamic>> build(arg) async {
    // 1. Subscribe to the live socket stream FIRST, before the REST fetch
    final chatService = ref.read(chatHubServiceProvider);
    final subscription = chatService.onGroupMessage.listen((message) {
      _handleIncomingMessage(message);
    });

    // 2. Always cancel the subscription when this provider is disposed —
    //    otherwise you leak a listener every time this rebuilds
    ref.onDispose(subscription.cancel);

    // 3. Fetch the initial snapshot from REST, as you already do
    return _fetchGroupChats();
  }

  Future<List<dynamic>> _fetchGroupChats() async {
    try {
      final repo = ref.read(allChatRepository);
      final response = await repo.getAllChat();
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("get all chat = ${response.data}");
        final list = (response.data as List<dynamic>? ?? []);
        return list.map((e) => ChatSummary.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        log("error while getting all chats : ${response.error}");
        FlashCard.showError(errorMessage: "Something went wrong to get all chats");
        return [];
      }
    } catch (e) {
      log('error getting all chats : $e');
      return [];
    } finally {
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> message) {
    final current = state.value ?? [];
    final senderId = message['senderId'] as String?;
    if (senderId == null) return;

    // find if a conversation with this sender already exists
    final index = current.indexWhere((c) => c.userId == senderId);
    final updated = [...current];

    if (index != -1) {
      // bump existing conversation to the top with new last message
      final existing = updated.removeAt(index);
      updated.insert(0, existing.copyWith(
        lastMessage: message['content'] as String? ?? '',
        lastMessageAt: DateTime.tryParse(message['timestamp']?.toString() ?? '') ?? DateTime.now(),
        unreadCount: existing.unreadCount + 1,
        username: message["senderUsername"],
      ));
    } else {
      // new conversation, add to top
      updated.insert(0, GroupSummary.fromJson({
        'userId': senderId,
        'username': message['senderUsername'] ?? 'Unknown',
        'lastMessage': message['content'],
        'lastMessageAt': message['timestamp'],
        'unreadCount': 1,
      }));
    }

    // THIS is what makes the UI actually update
    state = AsyncData(updated);
  }

  Future<void> refresh() async {
    state = AsyncData(await _fetchGroupChats());
  }
}