import 'dart:async';
import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/features/home_section/chat_section/repository/all_chat_repository.dart';
import 'package:next_talk/src/shared/toast/toast.dart';
import '../../../../core/network/signalr/controller/chat_connection_provider.dart';
import '../view/components/current_user_id_provider.dart';

typedef AllChatProviderNotifier =
AutoDisposeAsyncNotifierProviderFamily<AllChatProvider, void, String>;

final allChatProvider = AllChatProviderNotifier(AllChatProvider.new);

class AllChatProvider extends AutoDisposeFamilyAsyncNotifier<void, String> {
  int selectedTabBar = 0;
  String userId = "";

  @override
  FutureOr<void> build(arg) async {
    userId = arg;
    getAllChat();
  }

  void setTab(int index) {
    selectedTabBar = index;
    ref.read(selectedTabProvider.notifier).state = index; // 👈 sync global
    ref.notifyListeners();
  }

  Future<void> getAllChat() async {
    try{
      EasyLoading.show();
      final repo = ref.read(allChatRepository);
      final response = await repo.getAllChat(userId);
      if(response.statusCode == 200 || response.statusCode == 201) {
        log("get all chat = ${response.data}");
      }else{
        log("error while getting all chats : ${response.error}");
        FlashCard.showError(errorMessage: "Something went wrong to get all chats");
      }
    }catch(e) {
      log('error getting all chats : $e');
    }finally{
      EasyLoading.dismiss();
    }
  }


}