import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:next_talk/src/core/database/hive_storage.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_screen/direct/model/response/chat_model.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_screen/direct/response/direct_chat_repository.dart';
import '../../../../../../core/network/signalr/repository/chat_hub_repository.dart';
import '../../../../../../shared/toast/toast.dart';
import '../../../chat_summary_model/response/chat_summary_model.dart';

typedef DirectChatProviderNotifier =
    AutoDisposeAsyncNotifierProviderFamily<DirectChatProvider, List<DirectChatModel>, ChatSummary>;

final directChatProvider = DirectChatProviderNotifier(DirectChatProvider.new);

class DirectChatProvider extends AutoDisposeFamilyAsyncNotifier<List<DirectChatModel>, ChatSummary> {
  bool isTyping = false;
  bool get isPeerTyping => isTyping;
  TextEditingController sentText = TextEditingController();

  late final pagingController = PagingController<int, DirectChatModel>(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => fetchDirectChat(pageKey),
  );

  // final ScrollController scrollController = ScrollController();

  List<DirectChatModel>? chats;
  String? _currentUserName;

  @override
  FutureOr<List<DirectChatModel>> build(ChatSummary chat) async {
    // 1. Subscribe to the live socket stream FIRST, before the REST fetch
    final chatService = ref.read(chatHubServiceProvider);
    final store = ref.read(cacheServiceProvider);
    _currentUserName = await store.userName; // 👈 resolved once, reused synchronously below

    final messageSub = chatService.onDirectMessage.listen((data) {
      _handleIncomingMessage(chat.userId, data);
    });

    final typingSub = chatService.onTyping.listen((senderId) {
      if (senderId == chat.userId) {
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
      pagingController.dispose();
    });
    pagingController.fetchNextPage();
    return [];
  }

  Future<List<DirectChatModel>> fetchDirectChat(int pageKey) async {
    try {
      final repo = ref.read(directChatRepository);
      final response = await repo.getChats(arg.userId, pageKey, 3);
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

  void _prependMessage(DirectChatModel message) {
    final state = pagingController.value;
    final pages = state.pages;
    if (pages == null || pages.isEmpty) {
      pagingController.value = state.copyWith(pages: [[message]], keys: [0]);
      return;
    }
    pagingController.value = state.copyWith(
      pages: [[message, ...pages.first], ...pages.skip(1)],
    );
  }

  void _handleIncomingMessage(String peerId, Map<String, dynamic> data) {
    final message = DirectChatModel.fromJson(data);

    if (message.senderUsername == _currentUserName) return;

    final belongsHere = message.senderId == peerId  || message.recipientId == peerId;
    if (!belongsHere) return;

    _prependMessage(message);
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
      'recipientUsername': arg.username,
      'content': sentText.text.trim(),
    };
    // optimistic UI: show the message immediately, before server confirms

    final optimisticId = DateTime.now().microsecondsSinceEpoch.toString();
    final optimistic = DirectChatModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: sentText.text.trim(),
      sentAt: DateTime.now().toLocal(),
      isRead: false,
      senderId: currentUserId,
      senderUsername: senderUserName,
      recipientId: arg.userId,
    );

    sentText.clear();

    _prependMessage(optimistic);

    try {
      await chatService.sendDirectMessage(dto);
    } catch (e) {
      log('failed to send message: $e');
      FlashCard.showError(errorMessage: "Message failed to send");
      // roll back the optimistic entry on failure
      _removeMessage(optimisticId);
    }
  }

  void _removeMessage(String id) {
    final state = pagingController.value;
    final pages = state.pages;
    if (pages == null || pages.isEmpty) return;
    pagingController.value = state.copyWith(
      pages: pages.map((page) => page.where((m) => m.id != id).toList()).toList(),
    );
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
    await chatService.typingDirect(arg.userId);
  }

}
