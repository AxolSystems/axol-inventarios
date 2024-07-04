import 'package:flutter/material.dart';

import '../../../../../utilities/data_state.dart';
import '../warehouse_model.dart';
import 'concept_move_model.dart';
import 'inventory_move_row_model.dart';

class InventoryMoveModel {
  List<InventoryMoveRowModel> moveList;
  List<ConceptMoveModel> concepts;
  List<WarehouseModel> warehouseList;
  ConceptMoveModel concept;
  TextEditingController document;
  DateTime date;
  WarehouseModel invTransfer;
  Map<String, DataState> states;

  InventoryMoveModel({
    required this.moveList,
    required this.concept,
    required this.date,
    required this.document,
    required this.concepts,
    required this.invTransfer,
    required this.states,
    required this.warehouseList,
  });

  static const String _moveList = 'moveList';
  static const String _concept = 'concept';
  static const String _date = 'date';
  static const String _document = 'document';
  static const String _concepts = 'concepts';
  static const String _invTransfer = 'invTransfer';
  static const String _save = 'save';
  static const String _emSelectConcept = 'Seleccione un concepto';
  static const String _emNotStock =  'Stock insuficiente en alguno de los productos';
  static const String _emNotProduct = 'Clave no valida en alguno de los productos';
  static const String _emNotRow = 'Agregue al menos un movimiento';
  static const String _emRowMissing = 'Falta agregar alguna clave o cantidad valida';

  String get tMoveList => _moveList;
  String get tConcept => _concept;
  String get tDate => _date;
  String get tDocument => _document;
  String get tConcepts => _concepts;
  String get tInvTransfer => _invTransfer;
  String get tSave => _save;
  String get emSelectConcept => _emSelectConcept;
  String get emNotStock => _emNotStock;
  String get emNotProduct => _emNotProduct;
  String get emNotRow => _emNotRow;
  String get emRowMissing => _emRowMissing;

  InventoryMoveModel.empty()
      : moveList = [],
        warehouseList = [],
        concept = ConceptMoveModel.empty(),
        date = DateTime.now(),
        document = TextEditingController(),
        concepts = [],
        invTransfer = WarehouseModel.empty(),
        states = {
          _moveList: DataState.empty(),
          _concept: DataState.empty(),
          _date: DataState.empty(),
          _document: DataState.empty(),
          _concepts: DataState.empty(),
          _invTransfer: DataState.empty(),
          _save: DataState.empty(),
        };
}
