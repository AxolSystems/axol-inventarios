import '../../../models/inventory_row_model.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';

class WbAddFormModel {
  List<InventoryRowModel> inventoryList;
  List<InventoryRowModel> waybillList;
  WarehouseModel warehouse;

  WbAddFormModel({
    required this.inventoryList,
    required this.warehouse,
    required this.waybillList,
  });

  WbAddFormModel.empty() : 
  inventoryList = [],
  waybillList = [],
  warehouse = WarehouseModel.empty();
}
