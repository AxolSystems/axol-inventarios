import 'package:axol_inventarios/modules/inventory_/inventory/model/inventory_move/inventory_move_row_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:uuid/uuid.dart';

import '../../inventory/model/inventory_move/inventory_move_model.dart';

class MovementModel {
  final String id;
  final DateTime time;
  final String code;
  final String description;
  final String document;
  final String warehouseName;
  final int warehouseId;
  final int concept;
  final String conceptName;
  final int conceptType;
  final double quantity;
  final String user;
  final double stock;
  final int folio;

  static String get lblId => 'Id';
  static String get lblTime => 'Fecha';
  static String get lblCode => 'Clave';
  static String get lblDescription => 'Descripción';
  static String get lblDocument => 'Documento';
  static String get lblWarehouse => 'Almacén';
  static String get lblConcept => 'Concepto';
  static String get lblConceptType => 'Tipo de concepto';
  static String get lblQuantity => 'Cantidad';
  static String get lblUser => 'Usuario';
  static String get lblStock => 'Existencias';
  static String get lblFolio => 'Folio';

  MovementModel({
    required this.id,
    required this.code,
    required this.concept,
    required this.conceptType,
    required this.conceptName,
    required this.description,
    required this.document,
    required this.quantity,
    required this.time,
    required this.warehouseName,
    required this.warehouseId,
    required this.user,
    required this.stock,
    required this.folio,
  });

  MovementModel.empty()
      : id = '',
        code = '',
        concept = -1,
        conceptType = -1,
        conceptName = '',
        description = '',
        document = '',
        quantity = 0,
        time = DateTime.now(),
        warehouseName = '',
        warehouseId = -1,
        user = '',
        stock = 0,
        folio = -1;

  MovementModel.fromRowOfDoc(
      InventoryMoveModel doc,
      InventoryMoveRowModel row,
      WarehouseModel warehouse,
      String userName,
      double newStock,
      int folioAvailable)
      : id = const Uuid().v4(),
        code = row.codeTf.text,
        concept = doc.concept.id,
        conceptType = doc.concept.type,
        conceptName = doc.concept.text,
        description = row.product.description,
        document = doc.document.text,
        quantity = double.tryParse(row.quantityTf.text) ?? 0,
        time = DateTime.now(),
        warehouseName = warehouse.name,
        warehouseId = warehouse.id,
        user = userName,
        stock = newStock,
        folio = folioAvailable; //Modificar

  MovementModel.transferDestiny(
      InventoryMoveModel doc,
      InventoryMoveRowModel row,
      WarehouseModel warehouseDestiny,
      String userName,
      double newStock,
      int folioAvailable)
      : id = const Uuid().v4(),
        code = row.codeTf.text,
        concept = 7,
        conceptType = 0,
        conceptName = 'Entrada por traspaso',
        description = row.product.description,
        document = doc.document.text,
        quantity = double.tryParse(row.quantityTf.text) ?? 0,
        time = DateTime.now(),
        warehouseName = warehouseDestiny.name,
        warehouseId = warehouseDestiny.id,
        user = userName,
        stock = newStock,
        folio = folioAvailable; //Modificar

  MovementModel.setQuantity(
      {required this.quantity, required MovementModel move})
      : code = move.code,
        concept = move.concept,
        conceptName = move.conceptName,
        conceptType = move.conceptType,
        description = move.description,
        document = move.document,
        folio = move.folio,
        id = move.id,
        stock = move.stock,
        time = move.time,
        user = move.user,
        warehouseId = move.warehouseId,
        warehouseName = move.warehouseName;

  MovementModel.setDocument(
      {required MovementModel move, required this.document})
      : code = move.code,
        concept = move.concept,
        conceptName = move.conceptName,
        conceptType = move.conceptType,
        description = move.description,
        quantity = move.quantity,
        folio = move.folio,
        id = move.id,
        stock = move.stock,
        time = move.time,
        user = move.user,
        warehouseId = move.warehouseId,
        warehouseName = move.warehouseName;

  static List<MovementModel> setDocAllMovements(
      {required List<MovementModel> movementList, required String doc}) {
    MovementModel movement;
    List<MovementModel> upMovementList = [];

    for (var element in movementList) {
      movement = MovementModel.setDocument(move: element, document: doc);
      upMovementList.add(movement);
    }

    return upMovementList;
  }
}
