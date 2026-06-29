import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/router/app_routes.dart';
import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../common/view/button/app_button.dart';
import '../../../../common/view/textfield/custom_textfield_with_label.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginAccount,
    required this.emailValidator,
    required this.passwordValidator,
    required this.formKey,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginAccount;
  final String? Function(String?) emailValidator;
  final String? Function(String?) passwordValidator;
  final Key formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            label: "Password",
            hintText: "**********",
            isFillColor: true,
            leading: Icon(Icons.password, color: bodyTextColor, size: 24),
            controller: passwordController,
            validator: passwordValidator,
          ),
          30.ph,
          AppButton(
            onPressed: onLoginAccount,
            child: Text("Sign In", style: context.text.titleMedium),
          ),
          20.ph,
          InkWell(
            onTap: () {},
            child: Text(
              "Forgot Password?",
              style: context.text.titleSmall?.copyWith(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
