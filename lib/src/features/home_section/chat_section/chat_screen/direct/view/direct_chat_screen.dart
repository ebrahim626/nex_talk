import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';

import '../../../../../../core/config/constant/assets_path.dart';
import '../../../../../../core/utils/extensions/context.dart';
import '../../../../../../core/utils/extensions/gap.dart';

class DirectChatScreen extends ConsumerWidget {
  const DirectChatScreen({super.key});

  static const String name = "direct_chat-screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      backGroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsetsGeometry.only(top: 18,bottom: 18,right: 16, left: 8),
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
                      "SA",
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
                    Text(
                      "Sarah Ahmed",
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
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
            child: ListView.builder(
              reverse: true,
              itemCount: 99,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemBuilder: (context, index) {
                bool isMe = true;
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
                            "SA",
                            style: context.text.bodyMedium?.copyWith(
                                color: secondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                        4.pw,
                      ],
                      Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          16.ph,
                          Container(
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(maxWidth: context.width * .7),
                            decoration: BoxDecoration(
                              color: isMe ? primaryColor : containerColor2 ,
                              borderRadius: BorderRadius.only(
                                bottomRight: isMe ? Radius.circular(0) : Radius.circular(8),
                                topLeft: Radius.circular(8),
                                bottomLeft: isMe ? Radius.circular(8) : Radius.circular(0),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Hey Are you free today?",
                              style: context.text.titleSmall?.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          2.ph,
                          Text(
                            "4:04 PM",
                            style: context.text.bodySmall?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
