import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';
import 'package:next_talk/src/features/home_section/add_contact/controller/add_contact_controller.dart';

import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';
import '../../../common/view/bottom_sheet/app_bottom_sheet.dart';
import '../../../common/view/button/app_button.dart';
import '../../../common/view/textfield/custom_textfield_with_label.dart';

class AddContactBottomSheet extends ConsumerWidget {
  const AddContactBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Material(
          color: bottomSheetColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddContactBottomSheet(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    ref.watch(addContactProvider);
    final notifier = ref.read(addContactProvider.notifier);

    return AppBottomSheetWidget(
      title: "Add Contact",
      child: Form(
        key: notifier.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFieldWithLabel(
              isFillColor: true,
              fillColor: containerColor,
              controller: notifier.userIdController,
              label: "USER NAME",
              hintText: "User name...",
              isRequired: " *",
            ),
            12.ph,
            CustomTextFieldWithLabel(
              isFillColor: true,
              fillColor: containerColor,
              controller: notifier.messageController,
              label: 'SENT MESSAGE',
              hintText: "Type message...",
              keyboardType: TextInputType.visiblePassword,
            ),
            30.ph,

            AppButton(
              borderRadius: 8,
              color: primaryColor,
              onPressed: () {},
              child: Text('Start Chat', style: context.text.titleMedium,),
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
