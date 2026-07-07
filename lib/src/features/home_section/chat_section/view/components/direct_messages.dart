import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/router/app_routes.dart';
import 'package:next_talk/src/core/service/text_formatter.dart';
import 'package:next_talk/src/core/service/time_formatter.dart';
import 'package:next_talk/src/features/home_section/chat_section/view/components/shimmer/direct_message_shimmer.dart';
import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../common/view/divider/app_divider.dart';
import '../../chat_summary_model/response/chat_summary_model.dart';
import '../../controller/all_chats_controller.dart';


class DirectMessages extends ConsumerWidget {
  const DirectMessages({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(allChatProvider(userId));
    final notifier = ref.watch(allChatProvider(userId).notifier);

    return chatsAsync.when(
      data: (chats) {
        if (chats.isEmpty) {
          return const Center(child: Text("No conversations yet"));
        }
        return RefreshIndicator(
          color: Colors.white,
          onRefresh: notifier.refresh,
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return _DirectMessageTile(chat: chat);
            },
            separatorBuilder: (context, index) =>
                AppDivider(height: 36, color: containerColor2),
            itemCount: chats.length,
          ),
        );
      },
      loading: () => const DirectMessageShimmer(),
      error: (e, _) {
        log("Error : $e");
       return Center(child: Text("Failed to load conversations"));
      },
    );
  }
}

class _DirectMessageTile extends StatelessWidget {
  const _DirectMessageTile({required this.chat});

  final ChatSummary chat;
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          AppRoutes.directChatScreenRoute,
          extra: chat,
        );
        log("sender UserID : ${chat.userId}");
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: containerColor, width: 2),
            ),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  child: Text(TextFormatter.avatarText(chat.username)),
                ),

                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color:  Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          10.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall,
                ),
                Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          10.pw,
          Column(
            children: [
              Text(
                DateTimeFormatter.timeAgo(chat.lastMessageAt),
                style: context.text.bodySmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              2.ph,
              if (chat.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: primaryColor,
                  ),
                  child: Text(
                    '${chat.unreadCount}',
                    style: context.text.titleSmall?.copyWith(fontSize: 13),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
