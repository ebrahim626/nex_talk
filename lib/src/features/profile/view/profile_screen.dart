import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';
import 'package:next_talk/src/features/profile/controller/profile_controller.dart';
import '../../../core/utils/extensions/context.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen ({super.key});

  static const String name = "profile-screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return CustomScaffold(
      appBar: AppBar(
        bottom: PreferredSize(preferredSize: Size(0, 8), child: SizedBox()),
        backgroundColor: logoContainerColor,
        leading: InkWell(
          onTap: context.pop,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: secondaryColor,
            ),
          ),
        ),
        title: Text(
          "Profile",
          style: context.text.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      backGroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                notifier.logout(context);
              },
              child: Text("Log Out"),
            ),
          ),
        ],
      ),
    );
  }
}
