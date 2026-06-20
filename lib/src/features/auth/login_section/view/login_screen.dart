import 'package:flutter/material.dart';
import 'package:next_talk/src/core/config/constant/assets_path.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';

import '../../../../core/utils/extensions/gap.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String name = "login_screen";

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backGroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetsPath.logo, width: 45, height: 45),
                15.pw,
                Text(
                  "NexTalk",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
            36.ph,
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: containerColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 18, color: hintTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            30.ph,

          ],
        ),
      ),
    );
  }
}
