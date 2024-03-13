import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/data_state.dart';
import '../../model/inventory_move/concept_move_model.dart';
import '../../model/inventory_move/inventory_move_model.dart';
import '../../model/inventory_move/inventory_move_row_model.dart';

/*class MovesFormCubit extends Cubit<InventoryMoveModel>{
  MovesFormCubit() : super(InventoryMoveModel.empty());

  void setProducts(List<InventoryMoveRowModel> products) {
    InventoryMoveModel form = state;
    form.moveList = products;
    emit(form);
  }

  void setConcept(ConceptMoveModel concept) {
    InventoryMoveModel form = state;
    form.concept = concept;
    emit(form);
  }

  void setConcepts(List<ConceptMoveModel> concepts) {
    InventoryMoveModel form = state;
    form.concepts = concepts;
    emit(form);
  }

  void setDate(DateTime date) {
    InventoryMoveModel form = state;
    form.date = date;
    emit(form);
  }

  void setDocument(String document) {
    InventoryMoveModel form = state;
    form.document = document;
    emit(form);
  }

  void setInvTransfer(WarehouseModel setInvTransfer) {
    InventoryMoveModel form = state;
    form.invTransfer = setInvTransfer;
    emit(form);
  }

  void setStatus(Map<String, DataState> states) {
    InventoryMoveModel form = state;
    form.states = states;
    emit(form);
  }

  void setForm(InventoryMoveModel form) {
    InventoryMoveModel newForm = state;
    newForm = form;
    emit(newForm);
  }

  void setQuantityMovRow(double quantity, int index) {
    InventoryMoveModel form = state;
    form.moveList[index].quantityTf.text = quantity.toString();
    emit(form);
  }

  void setCodeMoveRow(String code, int index) {
    InventoryMoveModel form = state;
    form.moveList[index].codeTf.text = code;
    emit(form);
  }
}*/