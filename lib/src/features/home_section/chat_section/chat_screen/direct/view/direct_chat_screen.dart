import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/router/app_routes.dart';
import 'package:next_talk/src/core/service/text_formatter.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_screen/direct/controller/direct_chat_controller.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_summary_model/response/chat_summary_model.dart';
import '../../../../../../core/database/hive_storage.dart';
import '../../../../../../core/utils/extensions/context.dart';
import '../../../../../../core/utils/extensions/gap.dart';
import '../../../view/components/current_user_id_provider.dart';

class DirectChatScreen extends ConsumerWidget {
  const DirectChatScreen({super.key, required this.chat});

  final ChatSummary chat;

  static const String name = "direct_chat-screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(directChatProvider(chat.userId));
    final notifier = ref.read(directChatProvider(chat.userId).notifier);
    final currentUserId = ref.watch(currentUserIdProvider);

    return CustomScaffold(
      backGroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsetsGeometry.only(
              top: 18,
              bottom: 18,
              right: 16,
              left: 8,
            ),
            color: logoContainerColor,
            child: Row(
              children: [
                InkWell(
                  onTap: context.pop,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: secondaryColor,
                    ),
                  ),
                ),
                13.pw,
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: containerColor, // Border color
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: containerColor2,
                    child: Text(
                      TextFormatter.avatarText(chat.username),
                      style: context.text.bodyMedium?.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                15.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        notifier.logout(context);
                      },
                      child: Text(
                        chat.username,
                        style: context.text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 7,
                          backgroundColor: successColor,
                        ),
                        6.pw,
                        Text(
                          "Online",
                          style: context.text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: successColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: chatsAsync.when(
              data: (chats) {
                if (chats.isEmpty) {
                  return const Center(child: Text("Say hello 👋"));
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: chats.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemBuilder: (context, index) {
                    // reverse: true means index 0 is the bottom (latest) message
                    // final message = chats[chats.length - 1 - index];
                    final message = chats[index]; // No need to reverse since we use reverse: true
                    final isMe = message.senderId == currentUserId;

                    return Align(
                      alignment: isMe ? Alignment.bottomRight : Alignment.topLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe) ...[
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: containerColor2,
                              child: Text(
                                message.senderUsername.isNotEmpty
                                    ? message.senderUsername.substring(0, 1).toUpperCase()
                                    : "?",
                                style: context.text.bodyMedium?.copyWith(
                                  color: secondaryColor, fontSize: 14, fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            6.pw,
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                16.ph,
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  constraints: BoxConstraints(
                                    maxWidth: context.width * .7 - (isMe ? 0 : 38),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe ? primaryColor : containerColor2,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: isMe ? Radius.circular(0) : Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                      bottomLeft: isMe ? Radius.circular(8) : Radius.circular(0),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: context.text.titleSmall?.copyWith(fontSize: 14),
                                  ),
                                ),
                                2.ph,
                                Text(
                                  TimeOfDay.fromDateTime(message.sentAt).format(context),
                                  style: context.text.bodySmall?.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Center(child: Text("Failed to load messages")),
            ),
          ),
          if (notifier.isPeerTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "••• typing...",
                  style: context.text.bodySmall?.copyWith(color: secondaryColor),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            color: logoContainerColor,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primaryColor),
                    ),
                    child: Row(
                      children: [
                        const Text("😊", style: TextStyle(fontSize: 22)),
                        10.pw,
                        Expanded(
                          child: TextField(
                            controller: notifier.sentText,
                            style: context.text.bodyMedium,
                            onChanged: (_) => notifier.notifyTyping(),
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Type a message...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                18.pw,
                InkWell(
                  onTap: () {
                    notifier.sendMessage();
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
