import 'package:flutter/material.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';

import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';
import '../../../common/view/bottom_sheet/app_bottom_sheet.dart';
import '../../../common/view/button/app_button.dart';
import '../../../common/view/textfield/custom_textfield_with_label.dart';

class AddGroupBottomSheet extends StatelessWidget {
  const AddGroupBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
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
  Widget build(BuildContext context,) {

    return AppBottomSheetWidget(
      title: "Create Group",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFieldWithLabel(
            isFillColor: true,
            fillColor: containerColor,
            controller: TextEditingController(),
            label: "Group Name",
            hintText: "type group name",
            isRequired: "*",
          ),
          12.ph,
          CustomTextFieldWithLabel(
            isFillColor: true,
            fillColor: containerColor,
            controller: TextEditingController(),
            label: 'Add Member',
            hintText: "Search users to add...",
            isRequired: "*",
            keyboardType: TextInputType.visiblePassword,
          ),
          30.ph,

          AppButton(
            borderRadius: 8,
            color: primaryColor,
            onPressed: () {},
            child: Text('Create Group', style: context.text.titleMedium,),
          ),
        ],
      ),
    );
  }
}
