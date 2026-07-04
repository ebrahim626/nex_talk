import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:next_talk/src/core/router/app_routes.dart';
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

    return chatsAsync.when(
      data: (chats) {
        if (chats.isEmpty) {
          return const Center(child: Text("No conversations yet"));
        }
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return _DirectMessageTile(chat: chat);
          },
          separatorBuilder: (context, index) =>
              AppDivider(height: 36, color: containerColor2),
          itemCount: chats.length,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Failed to load conversations")),
    );
  }
}

class _DirectMessageTile extends StatelessWidget {
  const _DirectMessageTile({required this.chat});

  final ChatSummary chat;

  String get _initials {
    final parts = chat.username.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  String get _timeLabel {
    final diff = DateTime.now().difference(chat.lastMessageAt);
    if (diff.inMinutes < 1) return "now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    if (diff.inDays == 1) return "Yesterday";
    return DateFormat('MMM d').format(chat.lastMessageAt);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          AppRoutes.directChatScreenRoute,
          extra: {'peerId': chat.userId, 'peerName': chat.username},
        );
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: containerColor, width: 2),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: containerColor2,
              child: Text(
                _initials,
                style: context.text.bodyMedium?.copyWith(color: secondaryColor),
              ),
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
                _timeLabel,
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
