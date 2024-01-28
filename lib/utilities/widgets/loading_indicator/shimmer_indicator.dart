import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme.dart';

class ShimmerIndicator {
  static Widget box({required double height, required double width}) =>
      Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white10,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: ColorPalette.lightBackground,
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          height: height,
          width: width,
        ),
      );
  static Widget horizontalExpanded({required double height, int? flex}) =>
      Expanded(
          flex: flex ?? 1,
          child: Shimmer.fromColors(
            baseColor: Colors.black12,
            highlightColor: Colors.white10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: ColorPalette.lightBackground,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              height: height,
            ),
          ));
}

/*class Box extends StatelessWidget {
  final double height;
  final double width;
  const Box({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorPalette.lightBackground,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        height: height,
        width: width,
      ),
    );
  }
}

class HorizontalExpanded extends StatelessWidget {
  final double height;
  final int? flex;
  const HorizontalExpanded({super.key, required this.height, this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex ?? 1,
        child: Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ColorPalette.lightBackground,
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            height: height,
          ),
        ));
  }
}*/
