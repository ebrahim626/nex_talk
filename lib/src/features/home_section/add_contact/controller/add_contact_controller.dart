import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/features/home_section/add_contact/repository/add_contact_repository.dart';
import 'package:next_talk/src/features/home_section/chat_section/controller/all_chats_controller.dart';
import 'package:next_talk/src/shared/toast/toast.dart';

typedef AddContactProviderNotifier = AutoDisposeAsyncNotifierProvider<AddContactProvider, void>;

final addContactProvider = AddContactProviderNotifier(AddContactProvider.new);

class AddContactProvider extends AutoDisposeAsyncNotifier {

  TextEditingController userNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  FutureOr<dynamic> build() {

  }

  Future<void> addContact(BuildContext context) async {
    try{
      EasyLoading.show();
      if (!formKey.currentState!.validate()) {
        return;
      }

      final repo = ref.read(addContactRepository);
      final response = await repo.addNewConversation(userNameController.text, messageController.text);

      if(response.statusCode == 200) {
        FlashCard.showSuccess(
          message: "New contact added successfully",
        );
        userNameController.clear();
        messageController.clear();
        ref.invalidate(allChatProvider);
        context.pop();
      }else{
        log("error while adding new contact : ${response.data["message"]}");
        FlashCard.showError(errorMessage: "${response.data["message"]}");
      }

    }catch(e) {
      log("Error adding new user : $e");
      FlashCard.showError(errorMessage: "Failed to add contact");
    }finally{
      EasyLoading.dismiss();
    }
  }

}