import 'package:flutter/material.dart';

import '../../../models/inventory_row_model.dart';

class SrpFindBottomsheetFormModel {
  TextEditingController controller;
  List<InventoryRowModel> inventoryRowList;
  String? errorMessage;

  SrpFindBottomsheetFormModel({
    required this.controller,
    required this.inventoryRowList,
    required this.errorMessage,
  });

  SrpFindBottomsheetFormModel.empty() : 
  controller = TextEditingController(),
  inventoryRowList = [],
  errorMessage = null;
}