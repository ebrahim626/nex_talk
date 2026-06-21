import 'package:flutter/material.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';

import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';
import '../../../common/view/bottom_sheet/app_bottom_sheet.dart';
import '../../../common/view/button/app_button.dart';
import '../../../common/view/textfield/custom_textfield_with_label.dart';

class AddContactBottomSheet extends StatelessWidget {
  const AddContactBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: bottomSheetColor,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddContactBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context,) {

    return AppBottomSheetWidget(
      title: "Add Contact",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFieldWithLabel(
            isFillColor: true,
            fillColor: containerColor,
            controller: TextEditingController(),
            label: "USER ID",
            hintText: "User id...",
            isRequired: "*",
          ),
          12.ph,
          CustomTextFieldWithLabel(
            isFillColor: true,
            fillColor: containerColor,
            controller: TextEditingController(),
            label: 'OR SEARCH BY NAME',
            hintText: "Search Users...",
            isRequired: "*",
            keyboardType: TextInputType.visiblePassword,
          ),
          30.ph,

          AppButton(
            borderRadius: 8,
            color: primaryColor,
            onPressed: () {},
            child: Text('Start Chat', style: context.text.titleMedium,),
          ),
        ],
      ),
    );
  }
}
