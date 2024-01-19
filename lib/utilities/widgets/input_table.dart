import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/validation_form_model.dart';
import '../../modules/sale/sale_note/cubit/salenote_add/salenote_add_cubit.dart';
import '../theme/theme.dart';

class InputRow extends StatelessWidget {
  final List<InputCell> children;
  const InputRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children,
    );
  }
}

abstract class InputCell extends StatelessWidget {
  final int? flex;
  const InputCell({super.key, this.flex});
}

class TextFieldCell extends InputCell {
  final Color borderColor;
  final bool? isActionVisible;
  final TextEditingController? controller;
  final Function(String value)? onSubmitted;
  final Function(String value)? onChanged;
  final Function()? onPressed;
  final List<TextInputFormatter>? inputFormatters;
  final ValidationFormModel? valid;
  const TextFieldCell({
    super.key,
    super.flex,
    this.isActionVisible,
    required this.borderColor,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onPressed,
    this.inputFormatters,
    this.valid,
  });
  @override
  Widget build(BuildContext context) {
    final bool isValid = valid?.isValid ?? true;
    final String errorText = valid?.errorMessage ?? '';
    final flex_ = flex ?? 1;
    return Expanded(
        flex: flex_,
        child: Focus(
            child: SizedBox(
          height: 30,
          child: TextField(
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            controller: controller,
            style: Typo.bodyLight,
            cursorColor: isValid ? ColorPalette.primary : ColorPalette.caution,
            decoration: InputDecoration(
              contentPadding: const EdgeInsetsDirectional.symmetric(
                  vertical: 9, horizontal: 2),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                      color: isValid
                          ? ColorPalette.darkItems
                          : ColorPalette.caution)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                      color: isValid
                          ? ColorPalette.darkItems
                          : ColorPalette.caution)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                      color: isValid ? ColorPalette.primary : Colors.red)),
              isDense: true,
              prefixIcon: isValid
                  ? null
                  : SizedBox.square(
                      dimension: 30,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            foregroundColor: ColorPalette.caution,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialogAxol(text: errorText),
                            );
                          },
                          child: const Icon(
                            Icons.error_outline,
                            color: ColorPalette.caution,
                            size: 20,
                          )),
                    ),
              suffixIcon: isActionVisible ?? false
                  ? SizedBox.square(
                      dimension: 30,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide.none,
                          foregroundColor: ColorPalette.primary,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.search,
                          size: 20,
                          color: ColorPalette.lightItems,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        )));
  }
}

class LabelCell extends InputCell {
  final String text;
  final AlignmentGeometry? alignment;
  const LabelCell(this.text, {super.key, super.flex, this.alignment});
  @override
  Widget build(BuildContext context) {
    final flex_ = flex ?? 1;
    final text_ = text;
    return Expanded(
        flex: flex_,
        child: Container(
          height: 30,
          decoration:
              BoxDecoration(border: Border.all(color: ColorPalette.darkItems)),
          child: Align(
            alignment: alignment ?? Alignment.centerLeft,
            child: Text(
              text_,
              overflow: TextOverflow.ellipsis,
              style: Typo.bodyLight,
            ),
          ),
        ));
  }
}

class ButtonCell extends InputCell {
  final Function()? onPressed;
  final Widget child;
  const ButtonCell(
      {super.key, this.onPressed, required this.child, super.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex ?? 1,
        child: Container(
          height: 30,
          decoration:
              BoxDecoration(border: Border.all(color: ColorPalette.darkItems)),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              shape: const RoundedRectangleBorder(),
              foregroundColor: ColorPalette.primary,
            ),
            onPressed: onPressed,
            child: child,
          ),
        ));
  }
}

class MenuCell extends InputCell {
  final List<Widget> menuChildren;
  final Icon icon;
  const MenuCell({
    super.key,
    super.flex,
    required this.menuChildren,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex ?? 1,
        child: Container(
            height: 30,
            decoration: BoxDecoration(
                border: Border.all(color: ColorPalette.darkItems)),
            child: MenuAnchor(
              builder: (context, controller, child) {
                return IconButton(
                  splashRadius: 15,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: icon,
                );
              },
              menuChildren: menuChildren,
            )));
  }
}
