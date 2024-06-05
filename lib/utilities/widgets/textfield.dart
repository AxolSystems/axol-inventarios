import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final int? theme;
  const PrimaryTextField(
      {super.key, this.controller, this.onChanged, this.theme});

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
      ),
      onChanged: onChanged,
    );
  }
}
