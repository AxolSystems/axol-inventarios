import 'package:flutter/material.dart';

import '../../../../models/textfield_form_model.dart';
import '../../inventory/model/warehouse_model.dart';

class MovementFilterFormModel {
  TextfieldFormModel tfWarehose;
  List<WarehouseModel> warehouseList;
  List<DropdownMenuEntry<int>> entryList;
  DateTime initDate;
  DateTime endDate;
  bool filterDate;

  MovementFilterFormModel({
    required this.tfWarehose,
    required this.warehouseList,
    required this.initDate,
    required this.endDate,
    required this.filterDate,
    required this.entryList,
  });

  MovementFilterFormModel.empty()
      : tfWarehose = TextfieldFormModel.empty(),
        warehouseList = [],
        filterDate = false,
        initDate = DateTime(0),
        endDate = DateTime(3000),
        entryList = [const DropdownMenuEntry(value: 0, label: 'Inicial')];
}
