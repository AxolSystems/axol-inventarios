import 'package:flutter/material.dart';

/// Clase con constantes de todos los colores que se usan en la aplicación.
class ColorPalette {
  static const primary = Color.fromARGB(255, 132, 114, 242);
  static const secondary = Color.fromARGB(255, 98, 83, 197);
  static const secondaryDark = Color.fromARGB(255, 82, 69, 163);
  static const secondaryLight = Color.fromARGB(255, 133, 121, 214);
  static const tertiary = Color(0xFFffa532);
  static const alternate = Color(0xFFed7098);
  static const darkBackground = Color.fromARGB(255, 32, 32, 32);
  static const lightBackground = Color.fromARGB(255, 248, 248, 248);
  static const lightText = Color(0xFFf7fefe);
  static const darkText = Color(0xFF282828);
  static final secondaryText2 = const Color(0xFF282828).withOpacity(0.5);
  static const overlayButton = Color.fromARGB(28, 131, 114, 242);
  static const caution = Color.fromARGB(255, 180, 32, 22);
  static const correct = Color.fromARGB(255, 68, 228, 108);
  static const darkItems40 = Color.fromARGB(255, 46, 46, 46);
  static const darkItems30 = Color.fromARGB(255, 69, 69, 69);
  static const darkItems20 = Color.fromARGB(255, 92, 92, 92);
  static const darkItems10 = Color.fromARGB(255, 115, 115, 115);
  static const middleItems = Color.fromARGB(255, 141, 141, 141);
  static const lightItems10 = Color.fromARGB(255, 167, 167, 167);
  static const lightItems20 = Color.fromARGB(255, 190, 190, 190);
  static const lightItems30 = Color.fromARGB(255, 213, 213, 213);
  static const lightItems40 = Color.fromARGB(255, 236, 236, 236);
  static const filled = Color.fromARGB(10, 0, 0, 0);
  static const filledLight = Color.fromARGB(10, 255, 255, 255);
}

/// Clase que proporcionas los distintos colores de cada elemento
/// visual respecto al tema recibido mediante un entero numérico.
///
/// Temas respecto a índice recibido:
/// - 0: oscuro.
/// - 1: claro.
class ColorTheme {
  ///Color de fondo.
  static Color background(int theme) {
    switch (theme) {
      case 0:
        return ColorPalette.darkBackground;
      case 1:
        return ColorPalette.lightBackground;
      default:
        return ColorPalette.darkBackground;
    }
  }

  /// Color para elementos con menor contraste.
  static Color item10(int theme) {
    switch (theme) {
      case 0:
        return ColorPalette.darkItems10;
      case 1:
        return ColorPalette.lightItems10;
      default:
        return ColorPalette.darkItems10;
    }
  }

  /// Color para elementos con segundo menor contraste.
  static Color item20(int theme) {
    switch (theme) {
      case 0:
        return ColorPalette.darkItems20;
      case 1:
        return ColorPalette.lightItems20;
      default:
        return ColorPalette.darkItems20;
    }
  }

  /// Color para elementos con segundo mayor contraste.
  static Color item30(int theme) {
    switch (theme) {
      case 0:
        return ColorPalette.darkItems30;
      case 1:
        return ColorPalette.lightItems30;
      default:
        return ColorPalette.darkItems30;
    }
  }

  /// Color para elementos con mayor contraste.
  static Color item40(int theme) {
    switch (theme) {
      case 0:
        return ColorPalette.darkItems40;
      case 1:
        return ColorPalette.lightItems40;
      default:
        return ColorPalette.darkItems40;
    }
  }

  /// Color para texto.
  static Color text(int theme) {
    switch (theme) {
      case 0:
        return ColorPalette.lightText;
      case 1:
        return ColorPalette.darkText;
      default:
        return ColorPalette.lightText;
    }
  }

  /// Color usado para el fondo de los campos de texto.
  static Color fill(int theme) {
    switch (theme) {
      case 0:
        return ColorPalette.filledLight;
      case 1:
        return ColorPalette.filled;
      default:
        return ColorPalette.filledLight;
    }
  }

  /// Color para elementos que requieran de un cambio en el
  /// color secundario. Por ejemplo, cuando se pasa el cursor
  /// por encima de un botón.
  static Color secondaryTheme(int theme) {
    switch (theme) {
      case 0:
        return ColorPalette.secondaryDark;
      case 1:
        return ColorPalette.secondaryLight;
      default:
        return ColorPalette.secondaryDark;
    }
  }

  /// Color de capa que se sobrepone cuando un elemento está inhabilitado.
  static Color enabledButton(int theme) {
    switch (theme) {
      case 0:
        return const Color.fromARGB(125, 0, 0, 0);
      case 1:
        return const Color.fromARGB(124, 255, 255, 255);
      default:
        return const Color.fromARGB(125, 0, 0, 0);
    }
  }
}

/// TODO: Eliminar todas las fuentes sin usarse y documentar.
class Typo {
  static const title1 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: ColorPalette.lightText);
  static const title2 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: ColorPalette.lightText);
  static const textButton = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: ColorPalette.lightText);
  static const textField1 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: ColorPalette.darkText);
  static final hintText = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: ColorPalette.secondaryText2);
  static const labelText1 = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: ColorPalette.lightText);
  static const labelText2 = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: ColorPalette.darkText);
  static const bodyText1 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: ColorPalette.darkText);
  static const bodyText2 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: ColorPalette.darkText);
  static const bodyText3 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: ColorPalette.darkText);
  static const bodyText4 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: ColorPalette.lightText);
  static const bodyText5 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: ColorPalette.lightText);
  static const bodyText6 = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: ColorPalette.darkText);
  static const labelError = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.red);

  static const titleDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: ColorPalette.darkText);
  static const titleLightH1 = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 24,
      color: ColorPalette.lightText);
  static const titleLightH2 = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: ColorPalette.lightText);
  static TextStyle titleH2(int theme) => TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: ColorTheme.text(theme));
  static const subtitleDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: ColorPalette.darkText);
  static const subtitleLight = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: ColorPalette.lightText);
  static TextStyle subtitle(int theme) => TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: ColorTheme.text(theme));
  static const bodyDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: ColorPalette.darkText);
  static const bodyLight = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: ColorPalette.lightText);
  static TextStyle body(int theme) => TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: ColorTheme.text(theme));
  static const smallLabelDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: ColorPalette.darkItems20);
  static const labelDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: ColorPalette.darkItems20);
  static const boldLabelDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: ColorPalette.darkItems20);
  static const bigLabelLight = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 20,
      color: ColorPalette.lightItems10);
  static const labelLight = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: ColorPalette.lightItems10);
  static const smallLabelLight = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: ColorPalette.lightItems10);
  static TextStyle label(int theme) => TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: ColorTheme.item10(theme));
  static const bodyCaution = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: ColorPalette.caution);
  static const systemDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: ColorPalette.lightItems10);
  static TextStyle system(int theme) => TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: ColorTheme.text(theme));
  static const systemMiddle = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: ColorPalette.middleItems);

  //Button mobile
  static const mobileLight20 = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: ColorPalette.lightText);
  static const mobileDark20 = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: ColorPalette.darkText);
  static const mobileLight18 = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 18,
      color: ColorPalette.lightText);
  static const mobileDark18 = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 18,
      color: ColorPalette.darkText);
}

class BoxDecorationTheme {
  static BoxDecoration headerTable() => const BoxDecoration(
      color: ColorPalette.darkItems20,
      border: Border(
          bottom: BorderSide(
        width: 1,
        color: ColorPalette.darkItems20,
      )));

  static BoxDecoration rowTable() => const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 1,
        color: ColorPalette.darkItems20,
      )));
}
