import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../models/textfield_model.dart';
import '../theme/textfield_decoration.dart';

class FinderBar extends StatelessWidget {
  final TextfieldModel txtForm;
  final double? width;
  final double? height;
  final bool? isTxtExpand;
  final Color? backgroundColor;
  final bool? autoFocus;
  final bool? enabled;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onPressed;
  final InputDecoration? inputDecoration;
  final TextStyle? textStyle;
  final TextEditingController? textController;
  final EdgeInsetsGeometry? padding;

  const FinderBar({
    super.key,
    required this.txtForm,
    this.height,
    this.width,
    this.isTxtExpand,
    this.backgroundColor,
    this.autoFocus,
    this.enabled,
    this.onSubmitted,
    this.onChanged,
    this.onPressed,
    this.inputDecoration,
    this.textStyle,
    this.textController,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final double widthBar = width ?? 200;
    final double heightBar = height ?? 30;
    final bool isEsxpand = isTxtExpand ?? false;
    final bool autoFocusBar = autoFocus ?? false;
    final Color backColor = backgroundColor ?? ColorPalette.lightBackground;
    final InputDecoration decoration =
        inputDecoration ?? TextFieldDecoration.decorationFinder();
    final EdgeInsetsGeometry paddingBar =
        padding ?? const EdgeInsets.symmetric(horizontal: 12);
    TextField textField = TextField(
      controller: textController,
      autofocus: autoFocusBar,
      enabled: enabled,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      decoration: decoration,
      style: textStyle,
      cursorColor: ColorPalette.primary,
    );

    return Container(
        color: backColor,
        child: Padding(
          padding: paddingBar,
          child: Row(
            children: [
              isEsxpand == true
                  ? Expanded(
                      child: textField,
                    )
                  : SizedBox(
                      height: heightBar,
                      width: widthBar - heightBar,
                      child: textField,
                    ),
              IconButton(
                onPressed: onPressed,
                iconSize: heightBar,
                icon: const Icon(
                  Icons.close,
                  color: ColorPalette.darkItems20,
                ),
              )
            ],
          ),
        ));
  }
}
