import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:axol_inventarios/modules/array/model/array_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/utilities/format.dart';

import '../../../../models/data_response_model.dart';
import '../../../entity/model/entity_model.dart';
import '../../../formula/repository/formula_function.dart';
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
    List<ObjectModel> objects = [];
    List<PropertyModel> propFormulas = [];

    if (dataResponse.dataList is List<ObjectModel>) {
      objects = dataResponse.dataList as List<ObjectModel>;
    } else {
      objects = [];
    }

    /// Aquí está error int double de windows
    for (PropertyModel property in entity.propertyList) {
      header.add(property);
      if (property.propertyType == Prop.formula &&
          !property.dynamicValues[PropertyModel.dvFormula].contains('[query')) {
        propFormulas.add(property);
      }
    }

    for (var obj in objects) {
      row = {};
      for (var key in obj.map.keys) {
        final PropertyModel property =
            entity.propertyList.firstWhere((x) => x.key == key);
        final Prop prop = property.propertyType;
        if (prop == Prop.text) {
          row[key] = CellText(text: obj.map[key] ?? '');
        } else if (prop == Prop.double || prop == Prop.int) {
          row[key] = CellText(text: '${obj.map[key] ?? ''}');
        } else if (prop == Prop.bool) {
          row[key] = CellCheck(value: obj.map[key] ?? false);
        } else if (prop == Prop.time) {
          row[key] = CellText(
              text: obj.map[key] == null ? '' : FormatDate.dmyHm(obj.map[key]));
        } else if (prop == Prop.referenceObject) {
          final ReferenceObjectModel refObj = obj.map[key];
          final PropertyModel propRef = refObj.getPropView();
          if (propRef.propertyType == Prop.empty) {
            row[key] = CellReference(text: refObj.referenceObject.id);
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
                text: refObj.referenceObject.map[propRef.key] == null
                    ? ''
                    : FormatDate.dmyHm(DateTime.fromMillisecondsSinceEpoch(
                        refObj.referenceObject.map[propRef.key])));
          }
        } else if (prop == Prop.atomicObjList) {
          row[key] = CellAtomicObjList(atomicObjectList: obj.map[key] ?? []);
        } else if (prop == Prop.atomicObject) {
          row[key] = CellAtomicObject(atomicObject: obj.map[key] ?? []);
        } else if (prop == Prop.array) {
          final ArrayModel array = obj.map[key];
          row[key] = CellText(text: array.value);
        }
      }
      if (propFormulas.isNotEmpty) {
        for (PropertyModel propFormula in propFormulas) {
          final result = FormulaFunction.devExpressions(
              propFormula.dynamicValues[PropertyModel.dvFormula], obj);
          final String value;
          if (result is String) {
            value = result as String;
          } else {
            value = result.toString();
          }
          row[propFormula.key] = CellText(text: value);
        }
      }
      rowList.add(row);
    }
    table = TableModel(header: header, rowList: rowList, objects: objects);
    return table;
  }
}
