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

  TableFormModel({
    required this.theme,
    required this.columnWidth,
    required this.hover,
    required this.edit,
    required this.currentPage,
    required this.totalPage,
    required this.limitRows,
    required this.totalReg,
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
        totalReg = 0;

  /// Suma los valores de *columnWidth* y devuelve el total.
  double sum() {
    double total = 0;
    for (double num in columnWidth.values) {
      total = total + num;
    }
    return total;
  }
}
