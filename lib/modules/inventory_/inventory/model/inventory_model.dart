import 'package:uuid/uuid.dart';

import 'warehouse_model.dart';

class InventoryModel {
  String id;
  double stock;
  String retailManager;
  String name;
  String code;

  InventoryModel({
    required this.code,
    required this.id,
    required this.name,
    required this.retailManager,
    required this.stock,
  });

  InventoryModel.stockZero(String newCode, WarehouseModel warehouse)
      : code = newCode,
        id = const Uuid().v4(),
        name = warehouse.name,
        retailManager = warehouse.retailManager,
        stock = 0;
}
