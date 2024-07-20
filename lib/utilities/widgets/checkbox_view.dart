import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

class CheckboxView extends AxolWidget {
  final bool value;
  const CheckboxView({super.key, super.theme, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value) {
      return Icon(Icons.check_box_rounded,
          color: ColorTheme.item10(theme ?? 0));
    } else {
      return Icon(Icons.check_box_outline_blank,
          color: ColorTheme.item10(theme ?? 0));
    }
  }
}
