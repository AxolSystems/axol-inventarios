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
  const TextFieldCell({
    super.key,
    this.flex,
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
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.search,
                        size: 20,
                        color: ColorPalette.lightItems,
                      ))
                ],
              ),
            )));
  }
}

class LabelCell extends InputCell {
  final String text;
  final int? flex;
  const LabelCell(this.text, {super.key, this.flex});
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
          child: Text(text_),
        ));
  }
}
