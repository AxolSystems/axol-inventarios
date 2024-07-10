import 'package:flutter/material.dart';

import 'theme.dart';

class TextFieldDecoration {
  static InputDecoration decorationFinder() => InputDecoration(
        hintText: 'Buscar',
        hintStyle: Typo.hintText,
        border: InputBorder.none,
      );

  static InputDecoration inputForm({String? lblText, String? errorText}) => InputDecoration(
    labelText: lblText,
    labelStyle: Typo.labelLight,
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorPalette.primary),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorPalette.lightItems10),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorPalette.primaryAlert),
    ),
    disabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorPalette.darkItems20),
    ),
    errorText: errorText,
  );
}
