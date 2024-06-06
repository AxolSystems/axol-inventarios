import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';
import 'package:axol_inventarios/modules/axol_widget/table/model/table_model.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/theme/theme.dart';

class TableView extends StatelessWidget {
  final Color? color;
  final TableModel table;
  final int? theme;
  const TableView({super.key, this.color, required this.table, this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.amber,
      child: Column(
        children: [
          Row(
            children: headerWidget(table.header, theme ?? 0),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: table.rowList.length,
              itemBuilder: (context, index) {
                final row = table.rowList[index];
                return Row(
                  children: rowWidget(theme ?? 0, row, table.header),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> headerWidget(List<String> headerTitles, int theme) {
    List<Widget> widgetList = [];
    Widget widget;
    for (var element in headerTitles) {
      widget = SizedBox(
        height: 30,
        width: 100,
        child: Text(element, style: Typo.subtitle(theme)),
      );
      widgetList.add(widget);
    }
    return widgetList;
  }

  List<Widget> rowWidget(
      int theme, Map<String, TableCellModel> tableRow, List<String> header) {
    List<Widget> widgetList = [];
    Widget widget;

    for (var element in header) {
      if (tableRow.keys.contains(element)) {
        final cell = tableRow[element]!;
        if (cell is CellText) {
          widget = SizedBox(
            height: 30,
            width: 100,
            child: Text(cell.text, style: Typo.body(theme)),
          );
        } else {
          widget = const SizedBox(
            height: 30,
            width: 100,
          );
        }
      } else {
        widget = const SizedBox(
          height: 30,
          width: 100,
        );
      }

      widgetList.add(widget);
    }
    return widgetList;
  }
}
