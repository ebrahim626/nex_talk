import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_screen/direct/response/direct_chat_repository.dart';
import '../../../../../../shared/toast/toast.dart';

typedef DirectChatProviderNotifier =
    AutoDisposeAsyncNotifierProviderFamily<DirectChatProvider, void, String>;

final directChatProvider = DirectChatProviderNotifier(DirectChatProvider.new);

class DirectChatProvider extends AutoDisposeFamilyAsyncNotifier<void, String> {
  @override
  FutureOr<void> build(arg) async {
    fetchDirectChat(arg);
  }

  Future<void> fetchDirectChat(String userId) async {
    try {
      final repo = ref.read(directChatRepository);
      final response = await repo.getChats(userId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("get direct chat = ${response.data}");
      } else {
        log("error while getting all chats : ${response.error}");
        FlashCard.showError(
          errorMessage: "Something went wrong to get all chats",
        );
      }
    } catch (e) {
      log('error getting all chats : $e');
    } finally {}
  }
}
