import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';

import '../../../core/utils/extensions/context.dart';
import '../../../core/utils/extensions/gap.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen ({super.key});

  static const String name = "profile-screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        ],
      ),
    );
  }
}
