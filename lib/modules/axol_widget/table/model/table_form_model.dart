/// Modelo de datos de la vista de tabla.
class TableFormModel {
  int theme;
  Map<String, double> columnWidth;
  bool hover;
  bool edit;

  TableFormModel({
    required this.theme,
    required this.columnWidth,
    required this.hover,
    required this.edit,
  });

  /// Estado inicial del form de la vista de tabla.
  TableFormModel.empty()
      : theme = 0,
        columnWidth = {},
        hover = false,
        edit = false;

  /// Suma los valores de *columnWidth* y devuelve el total.
  double sum() {
    double total = 0;
    for (double num in columnWidth.values) {
      total = total + num;
    }
    return total;
  }
}
