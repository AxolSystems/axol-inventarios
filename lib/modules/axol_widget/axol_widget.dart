import 'package:flutter/material.dart';

import '../../utilities/theme/theme.dart';

abstract class AxolWidget extends StatelessWidget {
  final int? theme;
  const AxolWidget({super.key, this.theme});
}

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

  static Widget textTest(int theme, String text) {
    return Expanded(
        child: Container(
      color: ColorTheme.background(theme),
      child: Center(
        child: Text(
          text,
          style: Typo.bodyLight,
        ),
      ),
    ));
  }
}
