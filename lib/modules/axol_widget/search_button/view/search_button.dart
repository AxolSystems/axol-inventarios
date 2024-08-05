import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../object/model/object_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../../utilities/widgets/buttons/button.dart';
import '../cubit/search_ref_obj/search_ref_obj_cubit.dart';
import '../cubit/search_ref_obj/search_ref_obj_state.dart';
import '../model/search_ref_obj_form_model.dart';

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
