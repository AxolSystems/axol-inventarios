import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

class LinearProgressIndicatorAxol extends StatelessWidget {
  const LinearProgressIndicatorAxol({super.key});

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator(
      color: ColorPalette.secondary,
      backgroundColor: ColorPalette.primary,
    );
  }
}

class CircularProgressIndicatorAxol extends StatelessWidget {
  const CircularProgressIndicatorAxol({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: ColorPalette.lightItems10,
      backgroundColor: ColorPalette.darkBackground,
    );
  }
}