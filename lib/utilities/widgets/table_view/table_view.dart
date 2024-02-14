import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../button.dart';

abstract class TableView extends StatelessWidget {
  const TableView({super.key});
}

class DataHeadTable {
  final String text;
  final int flex;

  DataHeadTable({required this.text, required, required this.flex});

  DataHeadTable.text(this.text) : flex = 1;
}

class HeaderTable extends TableView {
  final List<DataHeadTable> dataList;
  const HeaderTable({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    List<Widget> contentList = [];
    Widget content;
    for (var data in dataList) {
      content = Expanded(
        flex: data.flex,
        child: Center(
          child: Text(
            data.text,
            style: Typo.subtitleLight,
          ),
        ),
      );
      contentList.add(content);
    }

    return Container(
      decoration: BoxDecorationTheme.headerTable(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: contentList,
        ),
      ),
    );
  }
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
