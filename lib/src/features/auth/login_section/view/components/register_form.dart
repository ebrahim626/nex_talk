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
    required this.userNameValidator,
    required this.emailValidator,
    required this.passwordValidator,
    required this.registerFormKey,
  });

  final TextEditingController emailController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;
  final VoidCallback onCreateAccount;
  final String? Function(String?) userNameValidator;
  final String? Function(String?) emailValidator;
  final String? Function(String?) passwordValidator;
  final Key registerFormKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: registerFormKey,
      child: Column(
        children: [
          CustomTextFieldWithLabel(
            label: "Email",
            hintText: "you@exmaple.com",
            isFillColor: true,
            leading: Icon(Icons.email_outlined, color: bodyTextColor, size: 24),
            controller: emailController,
            validator: emailValidator,
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
            validator: userNameValidator,
          ),
          12.ph,
          CustomTextFieldWithLabel(
            label: "Password",
            hintText: "**********",
            isFillColor: true,
            leading: Icon(Icons.password, color: bodyTextColor, size: 24),
            controller: passwordController,
            validator: passwordValidator,
          ),
          30.ph,
          AppButton(
            onPressed: onCreateAccount,
            child: Text("Create Account", style: context.text.titleMedium),
          ),
        ],
      ),
    );
  }
}
