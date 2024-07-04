import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const   Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logoAxol2.png',
      width: 400,
      height: 350,
      fit: BoxFit.fitHeight,
    );
  }
}
