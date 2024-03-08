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
  final List<ButtonTool> children;
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

class ButtonTool extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final double? height;

  const ButtonTool({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          foregroundColor: ColorPalette.primary,
          shape: const RoundedRectangleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Icon(
          icon,
          color: iconColor ?? ColorPalette.lightItems10,
          size: iconSize ?? 30,
        ),
      ),
    );
  }
}
