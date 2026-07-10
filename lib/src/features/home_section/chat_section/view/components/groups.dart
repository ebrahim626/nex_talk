import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/core/service/text_formatter.dart';
import 'package:next_talk/src/core/service/time_formatter.dart';
import 'package:next_talk/src/features/home_section/chat_section/chat_summary_model/response/group_summary_model.dart';
import 'package:next_talk/src/features/home_section/chat_section/controller/all_group_chats_controller.dart';
import 'package:next_talk/src/features/home_section/chat_section/view/components/shimmer/direct_message_shimmer.dart';
import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../common/view/divider/app_divider.dart';

class Groups extends ConsumerWidget {
  const Groups({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(allGroupChatsProvider(userId));
    final notifier = ref.read(allGroupChatsProvider(userId).notifier);

    return chatsAsync.when(
      data: (groups) {
        if (groups.isEmpty) {
          return const Center(child: Text("No conversations yet"));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final GroupChatModel group = groups[index];

                  return Row(
                    children: [
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
                            TextFormatter.avatarText(group.name),
                            style: context.text.bodyMedium?.copyWith(
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      10.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.titleSmall,
                            ),
                            Text(
                              "Hey, are you free tomorrow?",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.bodySmall,
                            ),
                            Text(
                              "${group.memberCount} members",
                              style: context.text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      10.pw,
                      Column(
                        children: [
                          Text(
                            "${DateTimeFormatter.timeAgo(group.createdAt)}",
                            style: context.text.bodySmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          2.ph,
                          Container(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 12,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: primaryColor,
                            ),
                            child: Text(
                              "3",
                              style: context.text.titleSmall?.copyWith(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) =>
                    AppDivider(height: 36, color: containerColor2),
                itemCount: groups.length,
              ),
            ),
          ],
        );
      },
        error: (Object error, StackTrace stackTrace) {
        log("Error while getting group chats : $error");
        return Center(child: Text("Failed to load groups"));
        },
        loading: () {
         return const DirectMessageShimmer();
        },
    );
  }
}
