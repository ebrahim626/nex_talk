import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/features/home_section/add_contact/repository/add_contact_repository.dart';
import 'package:next_talk/src/features/home_section/add_group/repository/add_group_repository.dart';
import 'package:next_talk/src/features/home_section/chat_section/controller/all_chats_controller.dart';
import 'package:next_talk/src/features/home_section/chat_section/controller/all_group_chats_controller.dart';
import 'package:next_talk/src/shared/toast/toast.dart';

typedef AddGroupProviderNotifier = AutoDisposeAsyncNotifierProvider<AddGroupProvider, void>;

final addGroupProvider = AddGroupProviderNotifier(AddGroupProvider.new);

class AddGroupProvider extends AutoDisposeAsyncNotifier {

  TextEditingController groupNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  FutureOr<dynamic> build() {

  }

  Future<void> addGroup(BuildContext context) async {
    try{
      EasyLoading.show();
      if (!formKey.currentState!.validate()) {
        return;
      }

      final repo = ref.read(addGroupRepository);
      final response = await repo.addNewGroup(groupNameController.text);

      if(response.statusCode == 200 || response.statusCode == 201) {
        FlashCard.showSuccess(
          message: "New group added successfully",
        );
        groupNameController.clear();
        ref.invalidate(allGroupChatsProvider);
        context.pop();
      }else{
        log("error while adding new group : ${response.data["message"]}");
        FlashCard.showError(errorMessage: "${response.data["message"]}");
      }

    }catch(e) {
      log("Error adding new group : $e");
      FlashCard.showError(errorMessage: "Failed to add group");
    }finally{
      EasyLoading.dismiss();
    }
  }

}