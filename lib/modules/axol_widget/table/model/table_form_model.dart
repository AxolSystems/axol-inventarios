/// Modelo de datos de la vista de tabla.
class TableFormModel {
  int theme;
  List<double> columnWidth;
  bool hover;

  TableFormModel({required this.theme, required this.columnWidth, required this.hover});

  /// Estado inicial del form de la vista de tabla.
  TableFormModel.empty()
      : theme = 0,
        columnWidth = [],
        hover = false;

  double sum() {
    double total = 0;
    for (var num in columnWidth) {
      total = total + num;
    }
    return total;
  }
}
