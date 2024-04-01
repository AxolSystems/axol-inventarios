import 'package:flutter/material.dart';

class ColorPalette {
  static const primary = Color.fromARGB(255, 132, 114, 242);
  static const secondary = Color(0xFF4649a8);
  static const tertiary = Color(0xFFffa532);
  static const alternate = Color(0xFFed7098);
  static const darkBackground = Color.fromARGB(255, 52, 52, 53);
  static const lightBackground = Color(0xFFfefefe);
  static const lightText = Color(0xFFf7fefe);
  static const darkText = Color(0xFF282828);
  static final secondaryText2 = const Color(0xFF282828).withOpacity(0.5);
  static const overlayButton = Color.fromARGB(28, 131, 114, 242);
  static const caution = Color.fromARGB(255, 180, 32, 22);
  static const correct = Color.fromARGB(255, 68, 228, 108);
  static const darkItems = Color.fromARGB(255, 78, 78, 78);
  static const lightItems10 = Color.fromARGB(255, 167, 167, 167);
  static const lightItems20 = Color.fromARGB(255, 226, 226, 226);
  static const filled = Color.fromARGB(10, 0, 0, 0);
}

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
  static const titleLight = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: ColorPalette.lightText);
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
  static const smallLabelDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: ColorPalette.darkItems);
  static const labelDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: ColorPalette.darkItems);
  static const boldLabelDark = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: ColorPalette.darkItems);
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
  static const bodyCaution = TextStyle(
      fontFamily: 'Source Sans Pro',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: ColorPalette.caution);
}

class BoxDecorationTheme {
  static BoxDecoration headerTable() => const BoxDecoration(
      color: ColorPalette.darkItems,
      border: Border(
          bottom: BorderSide(
        width: 1,
        color: ColorPalette.darkItems,
      )));

  static BoxDecoration rowTable() => const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 1,
        color: ColorPalette.darkItems,
      )));
}
