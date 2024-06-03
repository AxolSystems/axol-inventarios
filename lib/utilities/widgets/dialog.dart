import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AlertDialogAxol extends StatelessWidget {
  final String text;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final Function()? onPressed;
  const AlertDialogAxol(
      {super.key,
      required this.text,
      this.actions,
      this.icon,
      this.iconColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    final icon_ = icon ?? Icons.warning;
    final iconColor_ = iconColor ?? ColorPalette.caution;
    final List<Widget> actions_ = actions ??
        [
          OutlinedButton(
            onPressed: onPressed ??
                () {
                  Navigator.pop(context);
                },
            style: OutlinedButton.styleFrom(
                backgroundColor: ColorPalette.primary,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)))),
            child: const Text(
              'Aceptar',
              style: Typo.bodyLight,
            ),
          ),
        ];
    return AlertDialog(
        icon: Icon(
          icon_,
          color: iconColor_,
          size: 40,
        ),
        content: Text(
          text,
          style: Typo.bodyDark,
        ),
        actions: actions_);
  }
}

class LoadingDialog extends StatelessWidget {
  final String? text;
  const LoadingDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.darkBackground,
      icon: const Center(
        child: SizedBox.square(
          dimension: 30,
          child: CircularProgressIndicator(color: ColorPalette.primary),
        ),
      ),
      content: Row( mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text ?? 'Cargando...',
            style: Typo.bodyLight,
          )
        ],
      ),
    );
  }
}
