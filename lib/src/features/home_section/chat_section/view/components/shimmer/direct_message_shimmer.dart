import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/gap.dart';
import '../../../../../../core/utils/theme/theme.dart';
import '../../../../../common/view/divider/app_divider.dart';
import '../../../../../common/view/shimmer/shimmer_box.dart';

class DirectMessageShimmer extends StatelessWidget {
  const DirectMessageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_, __) =>
          AppDivider(height: 36, color: containerColor2),
      itemBuilder: (_, __) => const _DirectMessageShimmerTile(),
    );
  }
}

class _DirectMessageShimmerTile extends StatelessWidget {
  const _DirectMessageShimmerTile();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ShimmerBox(
          width: 48,
          height: 48,
          borderRadius: 24,
        ),
        10.pw,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerBox(
                width: 120,
                height: 16,
                borderRadius: 4,
              ),
              SizedBox(height: 8),
              ShimmerBox(
                width: double.infinity,
                height: 14,
                borderRadius: 4,
              ),
            ],
          ),
        ),

        10.pw,

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            ShimmerBox(
              width: 40,
              height: 12,
              borderRadius: 4,
            ),
            SizedBox(height: 8),
            ShimmerBox(
              width: 24,
              height: 24,
              borderRadius: 12,
            ),
          ],
        ),
      ],
    );
  }
}