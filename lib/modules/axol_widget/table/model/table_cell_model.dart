import '../../../object/model/atomic_object_model.dart';

/// Clase abstracta de donde heredan los diferentes modelos de datos de celdas.
abstract class TableCellModel {}

/// Modelo de datos de una celda de texto.
class CellText extends TableCellModel {
  final String text;

  CellText({required this.text});

  CellText.empty() : text = '';
}

/// Modelo de datos para una celda booleana.
class CellCheck extends TableCellModel {
  final bool value;

  CellCheck({required this.value});

  CellCheck.init() : value = false;
}

class CellReference extends TableCellModel {
  final String? text;
  final bool? valueBool;

  CellReference({this.text, this.valueBool});
}

class CellAtomicObjects extends TableCellModel {
  final List<AtomicObjectModel> atomicObjectList;
  CellAtomicObjects({required this.atomicObjectList});
}
