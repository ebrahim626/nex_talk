import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../common/view/button/app_button.dart';
import '../../../../common/view/textfield/custom_textfield_with_label.dart';

class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomTextFieldWithLabel(
          label: "Email",
          hintText: "you@exmaple.com",
          isFillColor: true,
          leading: Icon(
            Icons.email_outlined,
            color: bodyTextColor,
            size: 24,
          ),
          controller: TextEditingController(),
        ),
        12.ph,
        CustomTextFieldWithLabel(
          label: "Username",
          hintText: "Enter username",
          isFillColor: true,
          leading: Icon(
            Icons.account_circle_outlined,
            color: bodyTextColor,
            size: 24,
          ),
          controller: TextEditingController(),
        ),
        12.ph,
        CustomTextFieldWithLabel(
          label: "Password",
          hintText: "**********",
          isFillColor: true,
          leading: Icon(Icons.password, color: bodyTextColor, size: 24),
          controller: TextEditingController(),
        ),
        30.ph,
        AppButton(
          onPressed: () {},
          child: Text("Create Account", style: context.text.titleMedium),
        ),
      ],
    );
  }
}
