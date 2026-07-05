import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/features/home_section/chat_section/repository/all_chat_repository.dart';
import 'package:next_talk/src/shared/toast/toast.dart';
import '../../../../core/database/hive_storage.dart';
import '../../../../core/network/signalr/repository/chat_hub_repository.dart';
import '../chat_summary_model/response/chat_summary_model.dart';
import '../view/components/current_user_id_provider.dart';

typedef AllChatProviderNotifier =
AutoDisposeAsyncNotifierProviderFamily<AllChatProvider, List<dynamic>, String>;

final allChatProvider = AllChatProviderNotifier(AllChatProvider.new);

class AllChatProvider extends AutoDisposeFamilyAsyncNotifier<List<dynamic>, String> {
  int selectedTabBar = 0;
  String userId = "";

  @override
  FutureOr<List<dynamic>> build(arg) async {
    userId = arg;

    // 1. Subscribe to the live socket stream FIRST, before the REST fetch
    final chatService = ref.read(chatHubServiceProvider);
    final subscription = chatService.onDirectMessage.listen((message) {
      _handleIncomingMessage(message);
    });

    // 2. Always cancel the subscription when this provider is disposed —
    //    otherwise you leak a listener every time this rebuilds
    ref.onDispose(subscription.cancel);

    // 3. Fetch the initial snapshot from REST, as you already do
    return _fetchAllChats();
  }

  Future<List<dynamic>> _fetchAllChats() async {
    try {
      final repo = ref.read(allChatRepository);
      final response = await repo.getAllChat();
      if (response.statusCode == 200 || response.statusCode == 201) {
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

  void _handleIncomingMessage(Map<String, dynamic> message) async {
    final currentUserId = await ref.read(cacheServiceProvider).userId;
    final senderId = message['senderId'] as String?;
    final recipientId = message['recipientId'] as String?;
    if (senderId == null || recipientId == null || currentUserId == null) return;

    // The "other party" for this conversation row is whichever side ISN'T me —
    // never assume senderId is always the other person.
    final otherPartyId = senderId == currentUserId ? recipientId : senderId;

    // Never let this handler create/update a conversation entry pointing at myself.
    if (otherPartyId == currentUserId) return;

    final current = state.value ?? [];
    final index = current.indexWhere((c) => c.userId == otherPartyId);

    final updated = [...current];
    if (index != -1) {
      final existing = updated.removeAt(index);
      updated.insert(0, existing.copyWith(
        lastMessage: message['content'] as String? ?? '',
        // lastMessageAt: DateTime.tryParse(message['timestamp']?.toString() ?? '') ?? DateTime.now(),
        lastMessageAt: DateTime.tryParse(message['sentAt']?.toString() ?? '') ?? DateTime.now().toLocal(),
        unreadCount: senderId == currentUserId ? existing.unreadCount : existing.unreadCount + 1,
        username: senderId == currentUserId ? existing.username : message["senderUsername"],
      ));
    } else {
      // new conversation, add to top
      updated.insert(0, ChatSummary.fromJson({
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

  void setTab(int index) {
    selectedTabBar = index;
    ref.read(selectedTabProvider.notifier).state = index;
    ref.notifyListeners();
  }

  Future<void> refresh() async {
    state = AsyncData(await _fetchAllChats());
  }
}