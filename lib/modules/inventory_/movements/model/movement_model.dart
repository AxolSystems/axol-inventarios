import 'package:axol_inventarios/modules/inventory_/inventory/model/inventory_move/inventory_move_row_model.dart';
import 'package:uuid/uuid.dart';

import '../../inventory/model/inventory_move/inventory_move_model.dart';

class MovementModel {
  final String id;
  final DateTime time;
  final String code;
  final String description;
  final String document;
  final String warehouse;
  final int concept;
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
    required this.description,
    required this.document,
    required this.quantity,
    required this.time,
    required this.warehouse,
    required this.user,
    required this.stock,
    required this.folio,
  });

  MovementModel.empty()
      : id = '',
        code = '',
        concept = -1,
        conceptType = -1,
        description = '',
        document = '',
        quantity = 0,
        time = DateTime.now(),
        warehouse = '',
        user = '',
        stock = 0,
        folio = -1;

  MovementModel.fromRowOfDoc(InventoryMoveModel doc, InventoryMoveRowModel row,
      String warehouseName, String userName, double newStock)
      : id = const Uuid().v4(),
        code = row.code,
        concept = doc.concept.id,
        conceptType = doc.concept.type,
        description = row.description,
        document = doc.document,
        quantity = row.quantity,
        time = DateTime.now(),
        warehouse = warehouseName,
        user = userName,
        stock = newStock,
        folio = 0; //Modificar

  MovementModel.transferDestiny(
      InventoryMoveModel doc,
      InventoryMoveRowModel row,
      String warehouseDestiny,
      String userName,
      double newStock)
      : id = const Uuid().v4(),
        code = row.code,
        concept = 7,
        conceptType = 0,
        description = row.description,
        document = doc.document,
        quantity = row.quantity,
        time = DateTime.now(),
        warehouse = warehouseDestiny,
        user = userName,
        stock = newStock,
        folio = 0; //Modificar
}
