/// Modelo de datos de la vista de tabla.
class TableFormModel {
  int theme;

  TableFormModel({required this.theme});

  /// Estado inicial del form de la vista de tabla.
  TableFormModel.empty() : theme = 0;
}
