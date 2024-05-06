import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/format.dart';

class MovementFileFormModel {
  TextEditingController document;
  TextEditingController folio;
  TextEditingController concept;
  TextEditingController tfOmit;
  DateTime startTime;
  DateTime endTime;
  bool filterDate;
  DateTime startTimeMoves;
  DateTime endTimeMoves;
  bool filterDateMoves;
  List<WarehouseModel> warehouseList;
  int warehouseSelect;
  bool factorize;
  bool output;
  bool input;

  MovementFileFormModel({
    required this.document,
    required this.folio,
    required this.concept,
    required this.startTime,
    required this.endTime,
    required this.filterDate,
    required this.startTimeMoves,
    required this.endTimeMoves,
    required this.filterDateMoves,
    required this.warehouseList,
    required this.warehouseSelect,
    required this.factorize,
    required this.output,
    required this.input,
    required this.tfOmit,
  });

  MovementFileFormModel.empty()
      : document = TextEditingController(),
        folio = TextEditingController(),
        concept = TextEditingController(),
        startTime = FormatDate.startDay(DateTime.now()),
        endTime = FormatDate.endDay(DateTime.now()),
        filterDate = false,
        startTimeMoves = FormatDate.startDay(DateTime.now()),
        endTimeMoves = FormatDate.endDay(DateTime.now()),
        filterDateMoves = false,
        warehouseList = [],
        warehouseSelect = -2,
        factorize = false,
        output = true,
        input = true,
        tfOmit = TextEditingController();       
}
