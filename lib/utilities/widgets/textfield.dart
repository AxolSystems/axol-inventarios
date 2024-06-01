import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  const PrimaryTextField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Typo.bodyLight,
      cursorColor: ColorPalette.lightItems20,
      decoration: const InputDecoration(
        isDense: true,
        filled: true,
        fillColor: ColorPalette.filledLight,
        contentPadding: EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: ColorPalette.darkItems10)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: ColorPalette.lightItems10)),
      ),
    );
  }
}
