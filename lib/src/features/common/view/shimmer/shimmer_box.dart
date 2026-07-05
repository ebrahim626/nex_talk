import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double? borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: containerColor2,
      highlightColor: primaryColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
        ),
      ),
    );
  }
}
