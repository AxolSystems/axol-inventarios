import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';

class TableModel {
  final List<String> header;
  final List<Map<String, TableCellModel>> rowList;

  TableModel({required this.header, required this.rowList});
}
