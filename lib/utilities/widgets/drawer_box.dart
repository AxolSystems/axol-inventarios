import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

class DrawerBox extends StatelessWidget {
  final double? width;
  final List<Widget>? children;
  final List<Widget>? actions;
  final Widget? header;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const DrawerBox({
    super.key,
    this.width,
    this.children,
    this.header,
    this.actions,
    this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double drawerWidth;
    final List<Widget> drawerContent = children ?? [];
    final List<Widget> drawerActions = [];
    final Widget drawerHead = header ?? const Text('');
    final EdgeInsetsGeometry paddingDrawer = padding ?? const EdgeInsets.all(0);
    if (width == null) {
      drawerWidth = screenWidth * 0.5;
    } else if (width! <= 1 && width! > 0) {
      drawerWidth = screenWidth * width!;
    } else {
      drawerWidth = screenWidth * 0.5;
    }
    if (actions != null && actions!.isNotEmpty) {
      for (var element in actions!) {
        drawerActions.add(Padding(
          padding: const EdgeInsets.all(4),
          child: element,
        ));
      }
    }
    if (child == null) {
      return Row(
        children: [
          const Expanded(child: SizedBox()),
          Material(
            child: Container(
              color: ColorPalette.lightBackground,
              width: drawerWidth,
              height: screenHeight,
              child: Padding(
                padding: paddingDrawer,
                child: Column(
                  children: [
                    drawerHead,
                    Expanded(child: ListView(children: drawerContent)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: drawerActions,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Row(
        children: [
          const Expanded(child: SizedBox()),
          Material(
            child: Container(
              color: ColorPalette.lightBackground,
              width: drawerWidth,
              height: screenHeight,
              child: Padding(
                padding: paddingDrawer,
                child: Column(
                  children: [
                    drawerHead,
                    child!,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: drawerActions,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }
  }
}
