import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../common/view/button/app_button.dart';
import '../../../../common/view/textfield/custom_textfield_with_label.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFieldWithLabel(
          label: "Register",
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
          label: "Password",
          hintText: "**********",
          isFillColor: true,
          leading: Icon(Icons.password, color: bodyTextColor, size: 24),
          controller: TextEditingController(),
        ),
        30.ph,
        AppButton(
          onPressed: () {},
          child: Text("Sign In", style: context.text.titleMedium),
        ),
        20.ph,
        Text("Forgot Password?", style: context.text.titleSmall),
      ],
    );
  }
}
