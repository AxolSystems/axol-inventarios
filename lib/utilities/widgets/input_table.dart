import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/validation_form_model.dart';
import '../theme/theme.dart';
import 'loading_indicator/progress_indicator.dart';

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
  final Function(bool value) onFocusChange;
  final Color borderColor;
  //final bool? isActionVisible;
  final TextEditingController? controller;
  final Function(String value)? onSubmitted;
  final Function(String value)? onChanged;
  final Function()? onPressed;
  final List<TextInputFormatter>? inputFormatters;
  final ValidationFormModel? valid;
  final IconData? suffixIcon;
  final bool? isLoading;
  final bool? enabled;
  const TextFieldCell({
    super.key,
    super.flex,
    required this.onFocusChange,
    required this.borderColor,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onPressed,
    this.inputFormatters,
    this.valid,
    this.suffixIcon,
    this.isLoading,
    this.enabled,
  });
  @override
  Widget build(BuildContext context) {
    final bool isValid = valid?.isValid ?? true;
    final String errorText = valid?.errorMessage ?? '';
    final flex_ = flex ?? 1;
    final enableld_ = enabled ?? false ? true : isLoading ?? false;
    return Expanded(
        flex: flex_,
        child: Focus(
            onFocusChange: onFocusChange,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: isValid ? borderColor : ColorPalette.caution,
              )),
              height: 30,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      enabled: enableld_,
                      inputFormatters: inputFormatters,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      controller: controller,
                      style: Typo.bodyLight,
                      cursorColor:
                          isValid ? ColorPalette.primary : ColorPalette.caution,
                      decoration: InputDecoration(
                        border: InputBorder.none,
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
                        suffixIcon: isLoading == true
                            ? const SizedBox.square(
                                dimension: 30,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 14),
                                  child: CircularProgressIndicatorAxol(),
                                ),
                              )
                            : suffixIcon != null
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
                                      onPressed: onPressed,
                                      child: const Icon(
                                        Icons.search,
                                        size: 20,
                                        color: ColorPalette.lightItems10,
                                      ),
                                    ),
                                  )
                                : null,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

class LabelCell extends InputCell {
  final String text;
  final AlignmentGeometry? alignment;
  final IconData? suffixIcon;
  final bool? enabled;
  final Function()? onPressedSuffix;
  const LabelCell(
    this.text, {
    super.key,
    super.flex,
    this.alignment,
    this.suffixIcon,
    this.onPressedSuffix,
    this.enabled,
  });
  @override
  Widget build(BuildContext context) {
    final flex_ = flex ?? 1;
    final text_ = text;
    return Expanded(
        flex: flex_,
        child: Container(
          height: 30,
          decoration:
              BoxDecoration(border: Border.all(color: ColorPalette.darkItems20)),
          child: Row(
            children: [
              const SizedBox(width: 4),
              Expanded(
                  child: Align(
                alignment: alignment ?? Alignment.centerLeft,
                child: Text(
                  text_,
                  overflow: TextOverflow.ellipsis,
                  style: Typo.bodyLight,
                ),
              )),
              Visibility(
                  visible: suffixIcon != null,
                  child: SizedBox.square(
                    dimension: 30,
                    child: OutlinedButton(
                      onPressed: enabled == true ? onPressedSuffix : null,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: BorderSide.none,
                        foregroundColor: ColorPalette.primary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      child: Icon(
                        suffixIcon,
                        color: ColorPalette.lightItems10,
                        size: 20,
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}

class ButtonCell extends InputCell {
  final Function()? onPressed;
  final Widget child;
  final bool? enabled;
  const ButtonCell({
    super.key,
    this.onPressed,
    required this.child,
    super.flex,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex ?? 1,
        child: Container(
          height: 30,
          decoration:
              BoxDecoration(border: Border.all(color: ColorPalette.darkItems20)),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              shape: const RoundedRectangleBorder(),
              foregroundColor: ColorPalette.primary,
            ),
            onPressed: enabled == true ? onPressed : null,
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
                border: Border.all(color: ColorPalette.darkItems20)),
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
