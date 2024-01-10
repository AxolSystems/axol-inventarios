import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

class ToolBar extends StatelessWidget {
  final List<Widget> children;
  const ToolBar({super.key, required this.children});

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