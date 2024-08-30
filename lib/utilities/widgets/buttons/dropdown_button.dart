import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class PrimaryDropDownButton extends AxolWidget {
  final dynamic value;
  final List<DropdownMenuItem> items;
  final Function(dynamic value) onChanged;
  final double width;
  final EdgeInsetsGeometry? margin;
  const PrimaryDropDownButton({
    super.key,
    super.theme,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: ColorTheme.fill(theme ?? 0),
            contentPadding: const EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: ColorTheme.item20(theme ?? 0))),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: ColorTheme.item10(theme ?? 0))),
          ),
          dropdownColor: ColorTheme.background(theme ?? 0),
          value: value, //form.filterList[index].value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
