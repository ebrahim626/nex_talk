import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../common/view/divider/app_divider.dart';

class DirectMessages extends StatelessWidget {
  const DirectMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => Row(
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
                      "SA",
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
                        "Sarah Ahmed",
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
                    ],
                  ),
                ),
                10.pw,
                Column(
                  children: [
                    Text(
                      "2m",
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
            ),
            separatorBuilder: (context, index) =>
                AppDivider(height: 36, color: containerColor2),
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
