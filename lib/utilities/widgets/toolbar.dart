import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

class VerticalToolBar extends StatelessWidget {
  final List<Widget> children;
  const VerticalToolBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: ColorPalette.lightBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class HorizontalToolBar extends StatelessWidget {
  final BoxDecoration? boxDecoration;
  final List<Widget> children;
  const HorizontalToolBar(
      {super.key, required this.children, this.boxDecoration});

  @override
  Widget build(BuildContext context) {
    final boxDecoration_ = boxDecoration ??
        const BoxDecoration(
          backgroundBlendMode: BlendMode.color,
            color: ColorPalette.darkBackground,
            border: Border(left: BorderSide(color: ColorPalette.darkItems)));
    return Container(
      width: 50,
      decoration: boxDecoration_,
      child: Column(
        children: children,
      ),
    );
  }
}
