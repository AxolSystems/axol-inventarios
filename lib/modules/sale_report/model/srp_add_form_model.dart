import '../../../models/inventory_row_model.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import 'salereport_row_model.dart';

class SrpAddFormModel {
  List<InventoryRowModel> inventoryList;
  List<SaleReportRowModel> saleReportList;
  WarehouseModel warehouse;
  DateTime dateTime;

  SrpAddFormModel({
    required this.inventoryList,
    required this.warehouse,
    required this.saleReportList,
    required this.dateTime,
  });

  SrpAddFormModel.empty() : 
  inventoryList = [],
  saleReportList = [],
  warehouse = WarehouseModel.empty(),
  dateTime = DateTime(0);
}