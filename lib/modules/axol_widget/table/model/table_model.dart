import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/utilities/format.dart';

import '../../../../models/data_response_model.dart';
import '../../../entity/model/entity_model.dart';
import '../../../object/model/object_model.dart';
import '../../generic/model/data_object.dart';

/// Modelo que contiene los atributos de una tabla.
class TableModel extends DataObject {
  final List<PropertyModel> header;
  final List<Map<String, TableCellModel>> rowList;
  final List<ObjectModel> objects;

  TableModel({
    required this.header,
    required this.rowList,
    required this.objects,
  });

  /// Devuelve el estado inicial de [TableModel].
  TableModel.empty()
      : header = [],
        rowList = [],
        objects = [];

  /// Devuelve un modelo de tabla a partir de una lista de objetos y un entity.
  static TableModel dataObject(
      DataResponseModel dataResponse, EntityModel entity) {
    TableModel table;
    List<PropertyModel> header = [];
    List<Map<String, TableCellModel>> rowList = [];
    Map<String, TableCellModel> row;
    List<ObjectModel> objects;

    if (dataResponse.dataList is List<ObjectModel>) {
      objects = dataResponse.dataList as List<ObjectModel>;
    } else {
      objects = [];
    }

    for (var prop in entity.propertyList) {
      header.add(prop);
    }
    for (var obj in objects) {
      row = {};

      for (var key in obj.map.keys) {
        final Prop prop =
            entity.propertyList.firstWhere((x) => x.key == key).propertyType;
        if (prop == Prop.text) {
          row[key] = CellText(text: obj.map[key] ?? '');
        } else if (prop == Prop.double || prop == Prop.int) {
          row[key] = CellText(text: '${obj.map[key] ?? ''}');
        } else if (prop == Prop.bool) {
          row[key] = CellCheck(value: obj.map[key] ?? false);
        } else if (prop == Prop.time) {
          row[key] = CellText(
              text: FormatDate.dmyHm(
                  DateTime.fromMillisecondsSinceEpoch(obj.map[key] ?? 0)));
        } else if (prop == Prop.referenceObject) {
          final ReferenceObjectModel refObj =
              obj.map[key];
          final PropertyModel propRef = refObj.getPropView();
          if (propRef.propertyType == Prop.empty) {
            row[key] =
                CellReference(text: refObj.referenceObject.id);
          } else if (propRef.propertyType == Prop.text) {
            row[key] = CellReference(
                text: refObj.referenceObject.map[propRef.key] ?? '');
          } else if (propRef.propertyType == Prop.double ||
              propRef.propertyType == Prop.int) {
            row[key] = CellReference(
                text: '${refObj.referenceObject.map[propRef.key] ?? ''}');
          } else if (propRef.propertyType == Prop.bool) {
            row[key] = CellReference(
                valueBool: refObj.referenceObject.map[propRef.key] ?? false);
          } else if (propRef.propertyType == Prop.time) {
            row[key] = CellReference(
                text: FormatDate.dmyHm(DateTime.fromMillisecondsSinceEpoch(
                    refObj.referenceObject.map[propRef.key] ?? 0)));
          }
          
        }
      }
      rowList.add(row);
    }
    table = TableModel(header: header, rowList: rowList, objects: objects);
    return table;
  }
}
