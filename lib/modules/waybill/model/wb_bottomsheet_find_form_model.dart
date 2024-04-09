import 'package:flutter/material.dart';

import '../../../models/inventory_row_model.dart';

class WbButtonsheetFindFormModel {
  TextEditingController controller;
  List<InventoryRowModel> inventoryRowList;

  WbButtonsheetFindFormModel({
    required this.controller,
    required this.inventoryRowList,
  });

  WbButtonsheetFindFormModel.empty() : 
  controller = TextEditingController(),
  inventoryRowList = [];
}
