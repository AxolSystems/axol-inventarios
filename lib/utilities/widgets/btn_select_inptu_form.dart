import 'package:flutter/material.dart';

import '../theme/textfield_decoration.dart';
import '../theme/theme.dart';

class BtnSelectInputForm extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;
  final String? lblText;
  const BtnSelectInputForm(
      {super.key, required this.icon, this.onPressed, this.lblText});

  @override
  Widget build(BuildContext context) {
    final Function() onPressed_ = onPressed ?? () {};
    return Row(
      children: [
        Expanded(
            child: TextField(
          style: Typo.bodyLight,
          cursorColor: ColorPalette.primary,
          decoration: TextFieldDecoration.inputForm(lblText: lblText),
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
