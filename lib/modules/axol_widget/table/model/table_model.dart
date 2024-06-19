import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';
import 'package:axol_inventarios/modules/block/model/block_model.dart';
import 'package:axol_inventarios/modules/block/model/property_model.dart';

import '../../../object/model/object_model.dart';
import '../../generic/model/data_object.dart';

/// Modelo que contiene los atributos de una tabla.
class TableModel extends DataObject {
  final List<String> header;
  final List<Map<String, TableCellModel>> rowList;

  TableModel({required this.header, required this.rowList});

  /// Devuelve el estado inicial de [TableModel].
  TableModel.empty()
      : header = [],
        rowList = [];

  /// Devuelve un modelo de tabla a partir de una lista de objetos y un block.
  static TableModel dataObject(List<ObjectModel> objects, BlockModel block) {
    TableModel table;
    List<String> header = [];
    List<Map<String, TableCellModel>> rowList = [];
    Map<String, TableCellModel> row;

    for (var prop in block.propertyList) {
      header.add(prop.name);
    }
    for (var obj in objects) {
      row = {};

      for (var key in obj.map.keys) {
        final Prop prop = block.propertyList
            .firstWhere((x) => x.name == key)
            .propertyType;
        if (prop == Prop.text) {
          row[key] = CellText(text: obj.map[key]);
        }
      }
      rowList.add(row);
    }

    table = TableModel(header: header, rowList: rowList);
    return table;
  }
}
