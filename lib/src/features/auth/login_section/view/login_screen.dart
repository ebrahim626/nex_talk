import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/core/config/constant/assets_path.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/auth/login_section/login_controller/login_provider.dart';
import 'package:next_talk/src/features/auth/login_section/view/components/register_form.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';
import '../../../../core/utils/extensions/gap.dart';
import 'components/sign_in_form.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  static const String name = "login_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return CustomScaffold(
      backGroundColor: backgroundColor,
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 150),  // manual top spacing instead of center
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AssetsPath.logo, width: 45, height: 45),
                  15.pw,
                  Text("NexTalk", style: context.text.titleLarge),
                ],
              ),
              36.ph,
              // Tab switcher pill
               Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: containerColor,
                  ),
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: primaryColor,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: bodyTextColor,
                    labelStyle: context.text.titleMedium,
                    unselectedLabelStyle: context.text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: "Sign In"),
                      Tab(text: "Register"),
                    ],
                  ),
                ),
              30.ph,

              // Forms
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    SignInForm(),
                    RegisterForm(
                      emailController: notifier.emailController,
                      passwordController: notifier.passwordController,
                      userNameController: notifier.userNameController,
                      onCreateAccount: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
