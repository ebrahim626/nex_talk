import 'package:flutter/material.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String name = "login_screen";

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: Center(child: Text("Login Screen"),
        ),
    );
  }
}
