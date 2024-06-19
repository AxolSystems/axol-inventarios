/// Clase abstracta de donde heredan los diferentes modelos de datos de celdas.
abstract class TableCellModel {}

/// Modelo de datos de una celda de texto.
class CellText extends TableCellModel {
  final String text;

  CellText({required this.text});
}
