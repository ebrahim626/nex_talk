import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';

class DirectChatScreen extends ConsumerWidget {
  const DirectChatScreen({super.key,});

  static const String name = "direct_chat-screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return CustomScaffold(
      backGroundColor: backgroundColor,
      body: Column(
        children: [
          Text("chattt")
        ],
      ),
    );
  }
}
