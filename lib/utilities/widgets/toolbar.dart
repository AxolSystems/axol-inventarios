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
  final BoxBorder? border;
  final Color? color;
  final List<Widget> children;
  const HorizontalToolBar({
    super.key,
    required this.children,
    this.border,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.color,
        color: color ?? ColorPalette.darkBackground,
        border: border,
      ),
      child: ListView(
        children: children,
      ),
    );
  }
}
