import 'package:flutter/material.dart';

import '../../modules/axol_widget/generic/view/axol_widget.dart';
import '../theme/theme.dart';

class LabelField extends AxolWidget {
  final String text;
  const LabelField({super.key, super.theme, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorTheme.item20(theme ?? 0),
        ),
        borderRadius: BorderRadius.circular(6),
        color: ColorTheme.background(theme ?? 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          style: Typo.body(theme ?? 0),
        ),
      ),
    );
  }
}
