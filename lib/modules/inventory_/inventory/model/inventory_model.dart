import 'package:uuid/uuid.dart';

import 'warehouse_model.dart';

class InventoryModel {
  String id;
  double stock;
  int retailManager;
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

  InventoryModel.empty()
      : code = '',
        id = const Uuid().v4(),
        name = '',
        retailManager = -1,
        stock = 0;
}
