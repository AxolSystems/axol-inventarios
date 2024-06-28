import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

/// Widget principal de un campo de texto genérico de la aplicación.
class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final int? theme;
  final Widget? prefixIcon;
  final String? hintText;
  final TextStyle? hintStyle;
  const PrimaryTextField(
      {super.key,
      this.controller,
      this.onChanged,
      this.theme,
      this.prefixIcon,
      this.hintText,
      this.hintStyle});

  /// Devuelve widget general del campo de texto.
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Typo.body(theme ?? 0),
      cursorColor: ColorTheme.text(theme ?? 0),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: ColorTheme.fill(theme ?? 0),
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: ColorTheme.item20(theme ?? 0))),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: ColorTheme.item10(theme ?? 0))),
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
      ),
      onChanged: onChanged,
    );
  }
}
