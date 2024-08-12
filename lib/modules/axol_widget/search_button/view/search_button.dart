import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/theme/theme.dart';


class SearchButton extends AxolWidget {
  final ReferenceObjectModel referenceObject;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final Function()? onPressed;
  const SearchButton({
    required this.referenceObject,
    super.key,
    super.theme,
    this.margin,
    this.padding,
    this.width,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        child: OutlinedButton(
          style: ButtonStyle(
            alignment: Alignment.centerLeft,
            side: WidgetStatePropertyAll(
                BorderSide(color: ColorTheme.item20(theme_))),
            shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)))),
            backgroundColor: WidgetStatePropertyAll(ColorTheme.fill(theme_)),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  referenceObject.getPropViewText(),
                  style: Typo.body(theme_),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.search,
                  color: ColorTheme.item10(theme_),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
