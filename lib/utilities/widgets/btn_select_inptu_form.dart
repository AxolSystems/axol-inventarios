import 'package:flutter/material.dart';

import '../theme/textfield_decoration.dart';
import '../theme/theme.dart';

class BtnSelectInputForm extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;
  final String? lblText;
  final TextEditingController? controller;
  final String? errorText;

  const BtnSelectInputForm({
    super.key,
    required this.icon,
    this.onPressed,
    this.lblText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final Function() onPressed_ = onPressed ?? () {};
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: Typo.bodyLight,
          cursorColor: ColorPalette.primary,
          decoration: TextFieldDecoration.inputForm(
              lblText: lblText, errorText: errorText),
        )),
        IconButton(
          onPressed: onPressed_,
          icon: Icon(
            icon,
            color: ColorPalette.lightItems,
          ),
        ),
      ],
    );
  }
}
