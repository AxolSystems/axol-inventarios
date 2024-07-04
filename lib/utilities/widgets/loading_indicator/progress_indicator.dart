import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

/// Línea de progreso animado que sirve para indicar el estado 
/// de espera de un elemento o vista. Este es una línea de progreso 
/// personalizado para mantener el mismo estilo en toda la aplicación.
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