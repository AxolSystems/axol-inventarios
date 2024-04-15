import 'package:flutter/material.dart';

import '../../../models/inventory_row_model.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import 'salereport_row_model.dart';

class SrpAddFormModel {
  List<InventoryRowModel> inventoryList;
  List<SaleReportRowModel> saleReportList;
  WarehouseModel warehouse;
  DateTime dateTime;
  TextEditingController note;

  SrpAddFormModel({
    required this.inventoryList,
    required this.warehouse,
    required this.saleReportList,
    required this.dateTime,
    required this.note,
  });

  SrpAddFormModel.empty() : 
  inventoryList = [],
  saleReportList = [],
  warehouse = WarehouseModel.empty(),
  dateTime = DateTime(0),
  note = TextEditingController();
}