import 'package:flutter/material.dart';

import '../../../../../utilities/data_state.dart';

class InventoryMoveRowModel {
  //String code;
  String description;
  //double quantity;
  double weightUnit;
  double weightTotal;
  String concept;
  bool stockExist;
  Map<String, DataState> states;
  TextEditingController codeTf;
  TextEditingController quantityTf;
  DataState codeState;
  DataState quantityState;

  static const String _description = 'description';
  static const String _code = 'code';
  static const String _quantity = 'quantity';
  static const String _emNotProduct = 'Clave inexistente';
  static const String _emNotStock = 'Stock insuficiente';

  String get tDescription => _description;
  String get tCode => _code;
  String get tQuantity => _quantity;
  String get emNotProduct => _emNotProduct;
  String get emNotStock => _emNotStock;

  InventoryMoveRowModel({
    //required this.code,
    required this.description,
    //required this.quantity,
    required this.weightUnit,
    required this.weightTotal,
    required this.concept,
    required this.states,
    required this.stockExist,
    required this.codeTf,
    required this.quantityTf,
    required this.codeState,
    required this.quantityState,
  });

  InventoryMoveRowModel.empty()
      : //code = '',
        description = '',
        //quantity = 0,
        weightUnit = 0,
        weightTotal = 0,
        concept = '',
        stockExist = false,
        states = {
          _code: DataState(state: ElementState.initial, message: ''),
          _quantity: DataState(state: ElementState.initial, message: ''),
        },
        codeTf = TextEditingController.fromValue(TextEditingValue.empty),
        quantityTf = TextEditingController.fromValue(TextEditingValue.empty),
        codeState = DataState.empty(),
        quantityState = DataState.empty();
}
