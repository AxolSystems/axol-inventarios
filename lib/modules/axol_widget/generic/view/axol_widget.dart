import 'package:flutter/material.dart';

import '../../../../utilities/theme/theme.dart';

/// Una clase abstracta de la cual heredan todos los widgets de Axol. 
/// La función de los axolWidget es presentar los datos consultados 
/// en los bloques del cliente mediante un widget en la interfaz del 
/// usuario.
abstract class AxolWidget extends StatelessWidget {
  final int? theme;
  const AxolWidget({super.key, this.theme});
}

/// AxolWidget genérico que muestra un texto.
class TextAW extends AxolWidget {
  final String text;
  const TextAW({super.key, super.theme, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: ColorTheme.background(theme ?? 0),
      child: Center(
        child: Text(
          text,
          style: Typo.bodyLight,
        ),
      ),
    ));
  }
}

/// AxolWidget genérico que se presenta cuando no hay ningún 
/// axolWidget en pantalla.
class EmptyWidget extends AxolWidget {
  const EmptyWidget({super.key, super.theme});

  /// Devuelve widget con texto indicando que no se encontró 
  /// otro axolWidget.
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: ColorTheme.background(theme ?? 0),
      child: const Center(
        child: Text(
          'Widget no detectado',
          style: Typo.bodyLight,
        ),
      ),
    ));
  }
}
