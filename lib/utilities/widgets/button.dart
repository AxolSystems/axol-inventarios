import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class PrimaryButtonDialog extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final bool? enabled;
  final bool? loading;
  final Icon? icon;
  final TextStyle? textStyle;

  const PrimaryButtonDialog(
      {Key? key,
      this.onPressed,
      this.text,
      this.enabled,
      this.textStyle,
      this.loading,
      this.icon})
      : super(key: key);

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

/// Botón con estilo utilizado para barras de navegación
/// como de módulos o vistas de bloques.
class MainNavButton extends StatelessWidget {
  final bool? isHover;
  final Function()? onPressed;
  final IconData? icon;
  final String? text;
  final bool? isModule;
  final bool menuVisible;
  final int theme;
  const MainNavButton({
    super.key,
    this.isHover,
    this.onPressed,
    this.icon,
    this.text,
    this.isModule,
    required this.menuVisible,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: OutlinedButton(
          style: ButtonStyle(
            side: WidgetStateProperty.all(BorderSide.none),
            shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)))),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            //overlayColor: select == index
            overlayColor: isHover ?? false
                ? WidgetStateProperty.all(ColorTheme.item30(theme))
                : WidgetStateProperty.all(ColorTheme.item40(theme)),
            //backgroundColor: select == index
            backgroundColor: isHover ?? false
                ? WidgetStateProperty.all(ColorTheme.item30(theme))
                : null,
            foregroundColor: WidgetStateProperty.resolveWith((Set states) {
              if (states.contains(WidgetState.hovered) || (isHover ?? false)) {
                return ColorTheme.text(theme);
              } else {
                return ColorPalette.middleItems;
              }
            }),
            textStyle: WidgetStateProperty.all(Typo.systemDark),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Visibility(
                visible: icon != null,
                child: Icon(
                  icon,
                  size: 20,
                ),
              ),
              SizedBox(
                width: 129,
                child: Text(
                  text ?? '',
                  textAlign: TextAlign.start,
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Visibility(
                    replacement: const SizedBox(width: 10),
                    visible: (isHover ?? false) && (isModule ?? false),
                    child: menuVisible
                        ? Icon(
                            Icons.arrow_back_ios_new,
                            color: ColorTheme.text(theme),
                            size: 10,
                          )
                        : Icon(
                            Icons.arrow_forward_ios,
                            color: ColorTheme.text(theme),
                            size: 10,
                          )),
              )
            ],
          )),
    );
  }
}

/// Botón utilizado para acciones especificas del sistema, como
/// guardar, agregar un nuevo elemento, etc.
class PrimaryButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData? icon;
  final String? text;
  final EdgeInsetsGeometry? padding;
  final int? theme;
  final bool? isLoading;
  const PrimaryButton({
    super.key,
    this.onPressed,
    this.icon,
    this.text,
    this.padding,
    this.theme,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 28,
        child: Stack(
          children: [
            OutlinedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                      const BorderSide(color: ColorPalette.primary)),
                  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  overlayColor: WidgetStateProperty.all(
                      ColorTheme.secondaryTheme(theme ?? 0)),
                  backgroundColor:
                      WidgetStateProperty.all(ColorPalette.secondary),
                  foregroundColor:
                      WidgetStateProperty.all(ColorPalette.lightText),
                  textStyle: WidgetStateProperty.all(Typo.systemDark),
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: isLoading == true ? null : onPressed,
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: isLoading ?? false,
                        replacement: Visibility(
                            visible: icon != null,
                            child: Icon(
                              icon,
                              size: 15,
                            )),
                        child: const SizedBox.square(
                          dimension: 15,
                          child: CircularProgressIndicator(
                            color: ColorPalette.lightText,
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            (icon != null || isLoading == true) && (text != null),
                        child: const SizedBox(width: 8),
                      ),
                      Visibility(child: Text(text ?? ''))
                    ],
                  ),
                )),
            Visibility(
                visible: onPressed == null && isLoading != true,
                replacement: const SizedBox(),
                child: Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorTheme.enabledButton(theme ?? 0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                  ),
                )),
          ],
        ));
  }
}

/// Botón utilizado para acciones secundarias en una vista.
class SecondaryButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData? icon;
  final String? text;
  final EdgeInsetsGeometry? padding;
  final int? theme;
  final double? width;
  const SecondaryButton({
    super.key,
    this.onPressed,
    this.icon,
    this.text,
    this.padding,
    this.theme,
    this.width,
  });

  /// Construye el widget del botón secundario.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 28,
        width: width,
        child: Stack(
          children: [
            OutlinedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                      BorderSide(color: ColorTheme.item30(theme ?? 0))),
                  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  overlayColor:
                      WidgetStateProperty.all(ColorTheme.fill(theme ?? 0)),
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  foregroundColor:
                      WidgetStateProperty.all(ColorTheme.text(theme ?? 0)),
                  textStyle: WidgetStateProperty.all(Typo.systemDark),
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: onPressed,
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                          visible: icon != null,
                          child: Icon(
                            icon,
                            size: 15,
                          )),
                      Visibility(
                        visible: icon != null && text != null,
                        child: const SizedBox(width: 8),
                      ),
                      Visibility(child: Text(text ?? ''))
                    ],
                  ),
                )),
            Visibility(
                visible: onPressed == null,
                replacement: const SizedBox(),
                child: Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorTheme.enabledButton(theme ?? 0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                  ),
                )),
          ],
        ));
  }
}
