import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';
import 'package:next_talk/src/features/home_section/add_group/controller/add_group_controller.dart';

import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';
import '../../../common/view/bottom_sheet/app_bottom_sheet.dart';
import '../../../common/view/button/app_button.dart';
import '../../../common/view/textfield/custom_textfield_with_label.dart';

class AddGroupBottomSheet extends ConsumerWidget {
  const AddGroupBottomSheet({super.key});

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
            child: AddGroupBottomSheet(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    ref.watch(addGroupProvider);
    final notifier = ref.read(addGroupProvider.notifier);

    return AppBottomSheetWidget(
      title: "Create Group",
      child: Form(
        key: notifier.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFieldWithLabel(
              isFillColor: true,
              fillColor: containerColor,
              controller: notifier.groupNameController,
              label: "Group Name",
              hintText: "Type group name",
              isRequired: " *",
            ),
            // 12.ph,
            // CustomTextFieldWithLabel(
            //   isFillColor: true,
            //   fillColor: containerColor,
            //   controller: TextEditingController(),
            //   label: 'Add Member',
            //   hintText: "Search users to add...",
            // ),
            25.ph,

            AppButton(
              borderRadius: 8,
              color: primaryColor,
              onPressed: () {
                notifier.addGroup(context);
              },
              child: Text('Create Group', style: context.text.titleMedium,),
            ),
          ],
        ),
      ),
    );
  }
}
