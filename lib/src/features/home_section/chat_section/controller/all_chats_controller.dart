import 'dart:async';
import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/features/home_section/chat_section/repository/all_chat_repository.dart';
import 'package:next_talk/src/shared/toast/toast.dart';
import '../../../../core/network/signalr/repository/chat_hub_repository.dart';
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
      EasyLoading.show();
      final repo = ref.read(allChatRepository);
      final response = await repo.getAllChat();
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("get all chat = ${response.data}");
        return (response.data as List<dynamic>? ?? []);
      } else {
        log("error while getting all chats : ${response.error}");
        FlashCard.showError(errorMessage: "Something went wrong to get all chats");
        return [];
      }
    } catch (e) {
      log('error getting all chats : $e');
      return [];
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> message) {
    final current = state.value ?? [];
    final senderId = message['senderId'];

    // find if a conversation with this sender already exists
    final index = current.indexWhere((c) => c['userId'] == senderId);

    final updated = [...current];
    if (index != -1) {
      // bump existing conversation to the top with new last message
      final existing = Map<String, dynamic>.from(updated[index]);
      existing['lastMessage'] = message['content'];
      existing['lastMessageAt'] = message['timestamp'];
      existing['unreadCount'] = (existing['unreadCount'] ?? 0) + 1;
      updated.removeAt(index);
      updated.insert(0, existing);
    } else {
      // new conversation, add to top
      updated.insert(0, {
        'userId': senderId,
        'username': message['senderName'] ?? 'Unknown',
        'lastMessage': message['content'],
        'lastMessageAt': message['timestamp'],
        'unreadCount': 1,
      });
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