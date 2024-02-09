import 'package:axol_inventarios/utilities/theme/textfield_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

class TextFieldInputForm extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final double? space;
  final TextEditingController controller;
  final InputDecoration? decoration;
  final String? errorText;
  final TextStyle? style;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool? enabled;
  final bool? isFocus;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldInputForm({
    super.key,
    required this.controller,
    this.label,
    this.labelStyle,
    this.space,
    this.decoration,
    this.errorText,
    this.style,
    this.onChanged,
    this.onSubmitted,
    this.enabled,
    this.isFocus,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final labelTf = label ?? '';
    final labelStyleTf = labelStyle ?? Typo.bodyDark;
    final spaceTf = space ?? 8;
    final decorationTf = decoration ??
        TextFieldDecoration.inputForm(errorText: errorText, lblText: label);
    final bool enabledTf = enabled ?? true;
    final FocusNode focusNode = FocusNode();
    if (isFocus == true) {
      focusNode.requestFocus();
    }
    return Row(
      children: [
       /* Text(
          labelTf,
          style: labelStyleTf,
        ),
        SizedBox(
          width: spaceTf,
        ),*/
        Expanded(
          child: TextField(
            inputFormatters: inputFormatters,
            controller: controller,
            decoration: decorationTf,
            enabled: enabledTf,
            style: style,
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            cursorColor: ColorPalette.primary,
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
