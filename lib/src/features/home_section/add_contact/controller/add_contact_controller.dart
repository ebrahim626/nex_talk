import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/features/home_section/add_contact/repository/add_contact_repository.dart';
import 'package:next_talk/src/shared/toast/toast.dart';

typedef AddContactProviderNotifier = AutoDisposeAsyncNotifierProvider<AddContactProvider, void>;

final addContactProvider = AddContactProviderNotifier(AddContactProvider.new);

class AddContactProvider extends AutoDisposeAsyncNotifier {

  TextEditingController userIdController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  FutureOr<dynamic> build() {

  }

  Future<void> addContact() async {
    try{
      if (!formKey.currentState!.validate()) {
        return;
      }

      final repo = ref.read(addContactRepository);
      final response = await repo.addNewConversation(userIdController.text, messageController.text);

      if(response.statusCode == 200) {
        FlashCard.showSuccess(
          message: "New contact added successfully",
        );
      }

    }catch(e) {
      log("Error adding new user : $e");
      FlashCard.showError(errorMessage: "Failed to add contact");
    }
  }

}