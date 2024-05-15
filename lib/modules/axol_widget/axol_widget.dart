import 'package:flutter/material.dart';

import '../../utilities/theme/theme.dart';

abstract class AxolWidget extends StatelessWidget {
  const AxolWidget({super.key});
}

class TextAW extends AxolWidget {
  final String text;
  const TextAW({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          color: ColorPalette.darkBackground,
      child: Center(
        child: Text(
          text,
          style: Typo.bodyLight,
        ),
      ),
    ));
  }
}
