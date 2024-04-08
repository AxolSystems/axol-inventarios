import 'package:flutter/material.dart';

import '../../theme/theme.dart';

abstract class LeadingAppBarAxol extends StatelessWidget {
  const LeadingAppBarAxol({super.key});
}

class LeadingReturn extends LeadingAppBarAxol {
  const LeadingReturn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_ios,
        color: ColorPalette.lightText,
        size: 30,
      ),
    );
  }
}

class LeadingMenu extends LeadingAppBarAxol {
  final Function()? onPressed;
  const LeadingMenu({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.menu,
        color: ColorPalette.lightText,
        size: 30,
      ),
    );
  }
}
