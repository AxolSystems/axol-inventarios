import 'package:flutter/material.dart';

import '../theme/theme.dart';

class PrimaryButtonDialog extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final bool? isLoading;

  const PrimaryButtonDialog({
    Key? key,
    this.onPressed,
    this.text,
    this.isLoading,
  }) : super(key: key);

  @override
  State createState() => _PrimaryButtonDialog();
}

class _PrimaryButtonDialog extends State<PrimaryButtonDialog> {
  @override
  Widget build(BuildContext context) {
    final String fText = widget.text ?? 'Guardar';
    final Function() fOnPressed = widget.onPressed ?? () {};
    final bool isLoading_ = widget.isLoading ?? false;
    return OutlinedButton(
      onPressed: isLoading_ ? () {} : fOnPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isLoading_ ? ColorPalette.primary : ColorPalette.lightBackground,
        backgroundColor: ColorPalette.primary,
        side: BorderSide.none,
      ),
      child: Text(fText, style: Typo.bodyLight),
    );
  }
}

class SecondaryButtonDialog extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final bool? isLoading;

  const SecondaryButtonDialog({
    Key? key,
    this.onPressed,
    this.text,
    this.isLoading,
  }) : super(key: key);

  @override
  State createState() => _SecondaryButtonDialog();
}

class _SecondaryButtonDialog extends State<SecondaryButtonDialog> {
  @override
  Widget build(BuildContext context) {
    final String fText = widget.text ?? 'Regresar';
    final Function() fOnPressed = widget.onPressed ?? () {};
    final bool isLoading_ = widget.isLoading ?? false;
    return OutlinedButton(
      onPressed: isLoading_ ? () {} : fOnPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: ColorPalette.lightBackground,
        side: const BorderSide(color: ColorPalette.lightItems, width: 2),
        foregroundColor:
            isLoading_ ? ColorPalette.lightBackground : ColorPalette.lightItems,
      ),
      child: Text(fText, style: Typo.bodyDark),
    );
  }
}

class AlertButtonDialog extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final bool? isLoading;

  const AlertButtonDialog({
    Key? key,
    this.onPressed,
    this.text,
    this.isLoading,
  }) : super(key: key);

  @override
  State createState() => _AlertButtonDialog();
}

class _AlertButtonDialog extends State<AlertButtonDialog> {
  @override
  Widget build(BuildContext context) {
    final String fText = widget.text ?? 'Eliminar';
    final Function() fOnPressed = widget.onPressed ?? () {};
    final bool isLoading_ = widget.isLoading ?? false;
    return OutlinedButton(
      onPressed: isLoading_ ? () {} : fOnPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isLoading_ ? ColorPalette.caution : ColorPalette.lightBackground,
        backgroundColor: ColorPalette.caution,
        side: BorderSide.none,
      ),
      child: Text(fText, style: Typo.bodyLight),
    );
  }
}

class ButtonRowTable extends StatefulWidget {
  final Function()? onPressed;
  final Widget child;

  const ButtonRowTable({
    Key? key,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  State createState() => _ButtonRowTable();
}

class _ButtonRowTable extends State<ButtonRowTable> {
  @override
  Widget build(BuildContext context) {
    final Widget child = widget.child;
    final Function() onPressed_ = widget.onPressed ?? () {};
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorPalette.primary,
        side: BorderSide.none,
      ),
      onPressed: onPressed_,
      child: child,
    );
  }
}

class ButtonReturnView extends StatefulWidget {
  final Function()? onPressed;

  const ButtonReturnView({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  State createState() => _ButtonReturnView();
}

class _ButtonReturnView extends State<ButtonReturnView> {
  @override
  Widget build(BuildContext context) {
    final Function() onPressed_ = widget.onPressed ??
        () {
          Navigator.pop(context);
        };
    return ElevatedButton(
      onPressed: onPressed_,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.primary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        minimumSize: const Size(60, 60),
      ),
      child: const Icon(
        Icons.arrow_back_ios_rounded,
        color: ColorPalette.lightBackground,
      ),
    );
  }
}
