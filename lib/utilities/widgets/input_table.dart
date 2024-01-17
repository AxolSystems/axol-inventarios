import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  const InputCell({super.key});
}

class TextFieldCell extends InputCell {
  final int? flex;
  final Function(bool value) onFocusChange;
  final Color borderColor;
  final bool? isBtnVisible;
  const TextFieldCell({
    super.key,
    this.flex,
    this.isBtnVisible,
    required this.onFocusChange,
    required this.borderColor,
  });
  @override
  Widget build(BuildContext context) {
    final flex_ = flex ?? 1;
    return Expanded(
        flex: flex_,
        child: Focus(
            onFocusChange: onFocusChange,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: borderColor,
              )),
              height: 30,
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      style: Typo.bodyLight,
                      cursorColor: ColorPalette.primary,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isBtnVisible ?? false,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
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
                ],
              ),
            )));
  }
}

class LabelCell extends InputCell {
  final String text;
  final int? flex;
  final AlignmentGeometry? alignment;
  const LabelCell(this.text, {super.key, this.flex, this.alignment});
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
              style: Typo.bodyLight,
            ),
          ),
        ));
  }
}

class ButtonCell extends InputCell {
  final Function()? onPressed;
  final Widget child;
  final int? flex;
  const ButtonCell({super.key, this.onPressed, required this.child, this.flex});

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
