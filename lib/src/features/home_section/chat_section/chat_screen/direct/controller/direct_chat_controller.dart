import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/core/database/hive_storage.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_screen/direct/model/response/chat_model.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_screen/direct/response/direct_chat_repository.dart';
import '../../../../../../core/network/signalr/repository/chat_hub_repository.dart';
import '../../../../../../shared/toast/toast.dart';

typedef DirectChatProviderNotifier =
    AutoDisposeAsyncNotifierProviderFamily<DirectChatProvider, List<DirectChatModel>, String>;

final directChatProvider = DirectChatProviderNotifier(DirectChatProvider.new);

class DirectChatProvider extends AutoDisposeFamilyAsyncNotifier<List<DirectChatModel>, String> {
  bool isTyping = false;
  bool get isPeerTyping => isTyping;
  TextEditingController sentText = TextEditingController();
  // final ScrollController scrollController = ScrollController();

  List<DirectChatModel>? chats;

  @override
  FutureOr<List<DirectChatModel>> build(String peerId) async {
    // 1. Subscribe to the live socket stream FIRST, before the REST fetch
    final chatService = ref.read(chatHubServiceProvider);
    final messageSub = chatService.onDirectMessage.listen((data) {
      _handleIncomingMessage(peerId, data);
    });
    final typingSub = chatService.onTyping.listen((senderId) {
      if (senderId == peerId) {
        isTyping = true;
        ref.notifyListeners();
        // auto-clear after a short window since there's no explicit "stopped typing" event
        Future.delayed(const Duration(seconds: 3), () {
          isTyping = false;
          ref.notifyListeners();
        });
      }
    });

    ref.onDispose(() {
      messageSub.cancel();
      typingSub.cancel();
    });

    return fetchDirectChat(peerId);
  }

  Future<List<DirectChatModel>> fetchDirectChat(String userId) async {
    try {
      final repo = ref.read(directChatRepository);
      final response = await repo.getChats(userId);
      if (response.statusCode == 200 || response.statusCode == 201) {

        // Parse the list directly - API returns an array
        final List<dynamic> jsonList = response.data;
        chats = jsonList.map((json) => DirectChatModel.fromJson(json)).toList();
        log("fetch chats successfully ${chats?[1].isRead}");
        return chats ?? [];
      } else {
        log("error while getting all chats : ${response.error}");
        FlashCard.showError(
          errorMessage: "Something went wrong to get all chats",
        );
        return [];
      }
    } catch (e) {
      log('error getting all chats : $e');
      return [];
    }
  }

  void _handleIncomingMessage(String peerId, Map<String, dynamic> data) {
    final message = DirectChatModel.fromJson(data);
    final belongsHere = message.senderId == peerId  || message.recipientId == peerId;;
    if (!belongsHere) return;

    final current = state.value ?? [];
    state = AsyncData([...current,message]);
  }
  
  Future<void> sendMessage() async {
    if(sentText.text.trim().isEmpty) return;
    final store = ref.read(cacheServiceProvider);
    final currentUserId = await store.userId;
    final senderUserName = await store.userName;
    if (currentUserId == null || sentText.text.trim().isEmpty || senderUserName == null) {
      log("currentUserId | senderUserName one is empty --- ${sentText.text} --- ${currentUserId} --- ${senderUserName}");
      return;
    };

    final chatService = ref.read(chatHubServiceProvider);
    final dto = {
      'recipientId': arg,
      'content': sentText.text.trim(),
    };
    // optimistic UI: show the message immediately, before server confirms

    final optimistic = DirectChatModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: sentText.text.trim(),
      sentAt: DateTime.now().toLocal(),
      isRead: false,
      senderId: currentUserId,
      senderUsername: senderUserName,
      recipientId: arg,
    );

    sentText.clear();

    final current = state.value ?? [];
    state = AsyncData([optimistic,...current,]);

    try {
      await chatService.sendDirectMessage(dto);
    } catch (e) {
      log('failed to send message: $e');
      FlashCard.showError(errorMessage: "Message failed to send");
      // roll back the optimistic entry on failure
      state = AsyncData(current);
    }
  }

  // void scrollToEnd() {
  //   if (scrollController.hasClients) {
  //     scrollController.animateTo(
  //       0, // Since list is reversed, 0 is the end
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  Future<void> notifyTyping() async {
    final chatService = ref.read(chatHubServiceProvider);
    await chatService.typingDirect(arg);
  }

}
