import 'package:axol_inventarios/modules/inventory_/movements/view/movement_drawer_details.dart';
import 'package:flutter/material.dart';

import '../../../modules/inventory_/movements/model/movement_model.dart';
import '../../theme/theme.dart';
import '../button.dart';
import '../loading_indicator/progress_indicator.dart';

abstract class TableView extends StatelessWidget {
  const TableView({super.key});
}

class DataTableAxol {
  final String text;
  final int flex;

  DataTableAxol({required this.text, required, required this.flex});

  DataTableAxol.text(this.text) : flex = 1;
}

class HeaderTable extends TableView {
  final List<DataTableAxol> dataList;
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

class ListViewTable extends TableView {
  final bool? isLoading;
  final List<List<DataTableAxol>> rowList;
  final List? dataList;

  const ListViewTable({
    super.key,
    this.isLoading,
    required this.rowList,
    this.dataList
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading ?? false
          ? const Column(
              children: [
                LinearProgressIndicatorAxol(),
                Expanded(child: SizedBox())
              ],
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: rowList.length,
              itemBuilder: (context, index) {
                final List<DataTableAxol> row = rowList[index];
                List<Widget> contentList = [];
                Widget content;

                for (var data in row) {
                  content = Expanded(
                    flex: data.flex,
                    child: Center(
                      child: Text(
                        data.text,
                        style: Typo.labelText1,
                      ),
                    ),
                  );
                  contentList.add(content);
                }
                return Container(
                  height: 30,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: ColorPalette.darkItems),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: ButtonRowTable(
                        onPressed: () {
                          if (dataList is List<MovementModel>) {
                            final data = dataList![index];
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  MovementDrawerDetailsBuild(movement: data),
                            );
                          }
                        },
                        child: Row(
                          children: contentList,
                        ),
                      )),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class NavigateBarTable extends TableView {
  final int currentPage;
  final int limitPaga;
  final int totalReg;
  final Function()? onPressedLeft;
  final Function()? onPressedRight;
  const NavigateBarTable({
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
