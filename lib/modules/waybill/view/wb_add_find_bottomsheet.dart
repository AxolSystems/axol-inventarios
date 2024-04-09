import 'package:flutter/material.dart';

class WbAddFindBottomsheet extends StatelessWidget {
  const WbAddFindBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    return SizedBox(height: heightScreen * 0.7,);
  }
  
}