import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TextLabel extends StatelessWidget {
  final String text;
  final String label;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextOverflow? textOverflow;
  const TextLabel({
    super.key,
    required this.text,
    required this.label,
    this.textStyle,
    this.labelStyle,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ?? Typo.smallLabelDark,
        ),
        Text(
          text,
          style: textStyle ?? Typo.bodyDark,
          overflow: textOverflow,
        ),
      ],
    );
  }
}
