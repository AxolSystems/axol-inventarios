import 'package:flutter/material.dart';

import '../../../models/inventory_row_model.dart';

class WbBottomSheetFindFormModel {
  TextEditingController controller;
  List<InventoryRowModel> inventoryRowList;
  String? errorMessage;

  WbBottomSheetFindFormModel({
    required this.controller,
    required this.inventoryRowList,
    required this.errorMessage,
  });

  WbBottomSheetFindFormModel.empty() : 
  controller = TextEditingController(),
  inventoryRowList = [],
  errorMessage = null;
}
