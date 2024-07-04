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
  final bool? isLoading;

  const BtnSelectInputForm({
    super.key,
    required this.icon,
    this.onPressed,
    this.lblText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.errorText,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final Function() onPressed_ = onPressed ?? () {};
    final isLoading_ = isLoading ?? false;
    final icon_ = Icon(
      icon,
      color: ColorPalette.lightItems10,
    );
    return Row(
      children: [
        Expanded(
            child: TextField(
          enabled: !isLoading_,
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: Typo.bodyLight,
          cursorColor: ColorPalette.primary,
          decoration: TextFieldDecoration.inputForm(
              lblText: lblText, errorText: errorText),
        )),
        Visibility(
            visible: isLoading_,
            replacement: SizedBox.square(
              dimension: 30,
              child: IconButton(
                splashRadius: 20,
                padding: const EdgeInsets.all(0),
                onPressed: onPressed_,
                icon: icon_,
              ),
            ),
            child: icon_),
      ],
    );
  }
}
