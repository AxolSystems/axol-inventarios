import 'package:flutter/material.dart';

class LayoutWidget extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const LayoutWidget({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: backgroundColor,
          child: RawScrollbar(child: child),
        );
      },
    ));
  }
}
