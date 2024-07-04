import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';

import '../../../models/inventory_row_model.dart';

class WaybillListModel {
  final int id;
  final List<InventoryRowModel> list;
  final WarehouseModel warehouse;
  final DateTime date;

  WaybillListModel({
    required this.id,
    required this.date,
    required this.list,
    required this.warehouse,
  });

  WaybillListModel.empty()
      : id = -1,
        list = [],
        warehouse = WarehouseModel.empty(),
        date = DateTime(0);

  WaybillListModel.list(
      {required WaybillListModel waybillList, required this.list})
      : id = waybillList.id,
        warehouse = waybillList.warehouse,
        date = waybillList.date;

  WaybillListModel.emptyList(
      {required this.date, required this.id, required this.warehouse})
      : list = [];
}
