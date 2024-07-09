import 'package:axol_inventarios/modules/axol_widget/table/model/table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Modelo de datos de la vista de tabla.
class TableFormModel {
  int theme;
  Map<String, double> columnWidth;
  bool hover;
  bool edit;
  int currentPage;
  int totalPage;
  int limitRows;
  int totalReg;
  TextEditingController ctrlLimitRow;
  TextEditingController ctrlSearch;
  TableModel table;
  bool ascending;
  String? keyAscending;

  TableFormModel({
    required this.theme,
    required this.columnWidth,
    required this.hover,
    required this.edit,
    required this.currentPage,
    required this.totalPage,
    required this.limitRows,
    required this.totalReg,
    required this.ctrlLimitRow,
    required this.table,
    required this.ascending,
    required this.keyAscending,
    required this.ctrlSearch,
  });

  /// Estado inicial del form de la vista de tabla.
  TableFormModel.empty()
      : theme = 0,
        columnWidth = {},
        hover = false,
        edit = false,
        currentPage = 0,
        totalPage = 0,
        limitRows = 0,
        totalReg = 0,
        ctrlLimitRow = TextEditingController(),
        ctrlSearch = TextEditingController(),
        table = TableModel.empty(),
        ascending = false,
        keyAscending = null;

  /// Suma los valores de *columnWidth* y devuelve el total.
  double sum() {
    double total = 0;
    for (double num in columnWidth.values) {
      total = total + num;
    }
    return total;
  }
}
