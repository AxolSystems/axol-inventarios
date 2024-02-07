import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'button.dart';

abstract class TableView extends StatelessWidget {
  const TableView({super.key});
}

class NavigateBar extends TableView {
  final int currentPage;
  final int limitPaga;
  final int totalReg;
  final Function()? onPressedLeft;
  final Function()? onPressedRight;
  const NavigateBar({
    super.key,
    required this.currentPage,
    required this.limitPaga,
    required this.totalReg,
    this.onPressedLeft,
    this.onPressedRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: ColorPalette.darkItems))),
      child: Row(
        children: [
          SystemButton(
            width: 30,
            side: BorderSide.none,
            onPressed: onPressedLeft,
            child: const Icon(
              Icons.arrow_back,
              color: ColorPalette.lightItems,
            ),
          ),
          const VerticalDivider(
            color: ColorPalette.darkItems,
            thickness: 1,
            width: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$currentPage de $limitPaga',
              style: Typo.labelLight,
            ),
          ),
          const VerticalDivider(
            color: ColorPalette.darkItems,
            thickness: 1,
            width: 1,
          ),
          SystemButton(
            width: 30,
            side: BorderSide.none,
            onPressed: onPressedRight,
            child: const Icon(
              Icons.arrow_forward,
              color: ColorPalette.lightItems,
            ),
          ),
          const VerticalDivider(
            color: ColorPalette.darkItems,
            thickness: 1,
            width: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$totalReg registros',
              style: Typo.labelLight,
            ),
          ),
        ],
      ),
    );
  }
}
