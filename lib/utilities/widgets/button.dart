import 'package:flutter/material.dart';

import '../theme/theme.dart';

class PrimaryButtonDialog extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final bool? enabled;
  final bool? loading;
  final Icon? icon;
  final TextStyle? textStyle;

  const PrimaryButtonDialog({
    Key? key,
    this.onPressed,
    this.text,
    this.enabled,
    this.textStyle,
    this.loading,
    this.icon
  }) : super(key: key);

  @override
  State createState() => _PrimaryButtonDialog();
}

class _PrimaryButtonDialog extends State<PrimaryButtonDialog> {
  @override
  Widget build(BuildContext context) {
    final icon = widget.icon;
    final String text = widget.text ?? 'Guardar';
    final Function() fOnPressed = widget.onPressed ?? () {};
    final bool isLoading_ = widget.enabled ?? false;
    final TextStyle textStyle = widget.textStyle ?? Typo.bodyLight;
    final bool? loading = widget.loading;
    return OutlinedButton(
      onPressed: isLoading_ ? () {} : fOnPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isLoading_ ? ColorPalette.primary : ColorPalette.lightBackground,
        backgroundColor: ColorPalette.primary,
        side: BorderSide.none,
      ),
      //child: Text(fText, style: textStyle),
      child: icon != null
          ? Row(
              children: [icon, Text(text, style: textStyle)],
            )
          : loading == true
              ? const SizedBox(
                width: 20,
                height: 20,
                  child: CircularProgressIndicator(
                    color: ColorPalette.lightItems10,
                  ),
                )
              : Text(text, style: textStyle),
    );
  }
}

class SecondaryButtonDialog extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final TextStyle? textStyle;
  final bool? enabled;
  final Icon? icon;
  final BorderSide? border;
  final bool? loading;

  const SecondaryButtonDialog({
    Key? key,
    this.onPressed,
    this.text,
    this.enabled,
    this.icon,
    this.border,
    this.textStyle,
    this.loading,
  }) : super(key: key);

  @override
  State createState() => _SecondaryButtonDialog();
}

class _SecondaryButtonDialog extends State<SecondaryButtonDialog> {
  @override
  Widget build(BuildContext context) {
    final icon = widget.icon;
    final String text = widget.text ?? 'Regresar';
    final Function()? fOnPressed = widget.onPressed;
    final bool isLoading_ = widget.enabled ?? false;
    final BorderSide? border = widget.border;
    final TextStyle? textStyle = widget.textStyle;
    final bool? loading = widget.loading;
    return OutlinedButton(
      onPressed: isLoading_ ? null : fOnPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: ColorPalette.lightBackground,
        side: border ??
            const BorderSide(color: ColorPalette.lightItems10, width: 2),
        foregroundColor: isLoading_
            ? ColorPalette.lightBackground
            : ColorPalette.lightItems10,
      ),
      child: icon != null
          ? Row(
              children: [icon, Text(text, style: textStyle ?? Typo.bodyDark)],
            )
          : loading == true
              ? const SizedBox(
                width: 20,
                height: 20,
                  child: CircularProgressIndicator(
                    color: ColorPalette.lightItems10,
                  ),
                )
              : Text(text, style: textStyle ?? Typo.bodyDark),
    );
  }
}

class AlertButtonDialog extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final TextStyle? textStyle;
  final bool? isLoading;

  const AlertButtonDialog({
    Key? key,
    this.onPressed,
    this.text,
    this.textStyle,
    this.isLoading,
  }) : super(key: key);

  @override
  State createState() => _AlertButtonDialog();
}

class _AlertButtonDialog extends State<AlertButtonDialog> {
  @override
  Widget build(BuildContext context) {
    final String fText = widget.text ?? 'Eliminar';
    final TextStyle textStyle = widget.textStyle ?? Typo.bodyLight;
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
      child: Text(fText, style: textStyle),
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

class SystemButton extends StatefulWidget {
  final Function()? onPressed;
  final Widget child;
  final bool? isLoading;
  final double? height;
  final double? width;
  final BorderSide? side;

  const SystemButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.isLoading,
    this.height,
    this.width,
    this.side,
  }) : super(key: key);

  @override
  State createState() => _SystemButton();
}

class _SystemButton extends State<SystemButton> {
  @override
  Widget build(BuildContext context) {
    final Widget child = widget.child;
    final double? height = widget.height;
    final double? width = widget.width;
    final BorderSide side = widget.side ??
        const BorderSide(color: ColorPalette.darkItems20, width: 1);
    final Function() fOnPressed = widget.onPressed ?? () {};
    final bool isLoading_ = widget.isLoading ?? false;
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: isLoading_ ? () {} : fOnPressed,
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: ColorPalette.darkBackground,
            side: side,
            foregroundColor: ColorPalette.primary,
            shape: const ContinuousRectangleBorder()),
        child: child,
      ),
    );
  }
}
