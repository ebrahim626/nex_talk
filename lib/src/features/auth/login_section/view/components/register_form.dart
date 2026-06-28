import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../common/view/button/app_button.dart';
import '../../../../common/view/textfield/custom_textfield_with_label.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.emailController,
    required this.userNameController,
    required this.passwordController,
    required this.onCreateAccount,
  });

  final TextEditingController emailController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFieldWithLabel(
          label: "Email",
          hintText: "you@exmaple.com",
          isFillColor: true,
          leading: Icon(Icons.email_outlined, color: bodyTextColor, size: 24),
          controller: emailController,
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
          controller: userNameController,
        ),
        12.ph,
        CustomTextFieldWithLabel(
          label: "Password",
          hintText: "**********",
          isFillColor: true,
          leading: Icon(Icons.password, color: bodyTextColor, size: 24),
          controller: passwordController,
        ),
        30.ph,
        AppButton(
          onPressed: onCreateAccount,
          child: Text("Create Account", style: context.text.titleMedium),
        ),
      ],
    );
  }
}
