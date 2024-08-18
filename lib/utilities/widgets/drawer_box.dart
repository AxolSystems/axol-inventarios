import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

/// Widget utilizado para mostrar un drawer con estructura genérica,
/// con las propiedades para realizar sus cambios necesarios.
///
/// TODO: Falta docuemntar los demás metodos de DrawerBox.
class DrawerBox extends StatelessWidget {
  final double? width;
  final List<Widget>? children;
  final List<Widget>? actions;
  final Widget? header;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final int? theme;
  final Function()? onPressedOutside;

  const DrawerBox({
    super.key,
    this.width,
    this.children,
    this.header,
    this.actions,
    this.child,
    this.padding,
    this.theme,
    this.onPressedOutside,
  });

  /// Construye el widget central de DrawerBox.
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
        if (element is Expanded) {
          drawerActions.add(element);
        } else {
          drawerActions.add(Padding(
            padding: const EdgeInsets.all(4),
            child: element,
          ));
        }
      }
    }
    if (child == null) {
      return Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: onPressedOutside,
          )),
          Material(
            child: Container(
              color: ColorTheme.background(theme ?? 0),
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
          Expanded(
              child: GestureDetector(
            onTap: onPressedOutside,
          )),
          Material(
            child: Container(
              color: ColorTheme.background(theme ?? 0),
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

  static Widget rowKeyValue(String key, String value) => Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              key,
              style: Typo.systemDark,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Typo.bodyDark,
            ),
          ),
        ],
      );

  static Widget rowValues(List<DrawerCellText> values) {
    List<Widget> children = [];
    for (Widget value in values) {
      children.add(value);
    }
    return Row(
      children: children,
    );
  }

  static Widget headTable(List<DrawerCellText> values, {Color? color}) {
    List<Widget> children = [];
    for (Widget value in values) {
      children.add(value);
    }
    return Container(
      color: color,
      child: Row(
        children: children,
      ),
    );
  }
}

class DrawerCellText extends StatelessWidget {
  final String text;
  final int? flex;
  final TextStyle? style;
  final TextAlign? align;
  const DrawerCellText(
    this.text, {
    super.key,
    this.flex,
    this.style,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Text(
        text,
        style: style,
        textAlign: align,
      ),
    );
  }
}
