import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/inventory_move/concept_move_model.dart';
import '../../model/inventory_move/inventory_move_model.dart';
import '../../model/inventory_move/inventory_move_row_model.dart';
import '../../repository/inventory_concepts_repo.dart';
import 'inventory_move_state.dart';

class InventoryMoveCubit extends Cubit<InventoryMoveState> {
  InventoryMoveCubit() : super(InitialInventoryMoveState());

  Future<void> initLoad(InventoryMoveModel form) async {
    try {
      emit(InitialInventoryMoveState());
      emit(LoadingInventoryMoveState());
      List<ConceptMoveModel> conceptList;

      conceptList = await InventoryConceptsRepo().fetchAllConcepts();
      conceptList.sort((a, b) => a.id.compareTo(b.id),);
      form.concepts = conceptList;
      form.moveList.add(InventoryMoveRowModel.empty());

      emit(LoadedInventoryMoveState());
    } catch (e) {
      emit(ErrorInventoryMoveState(error: e.toString()));
    }
  }

  Future<void> load(InventoryMoveModel form) async {
    try {
      emit(InitialInventoryMoveState());
      emit(LoadingInventoryMoveState());

      emit(LoadedInventoryMoveState());
    } catch (e) {
      emit(ErrorInventoryMoveState(error: e.toString()));
    }
  }
}

class InventoryMoveForm extends Cubit<InventoryMoveModel> {
  InventoryMoveForm() : super(InventoryMoveModel.empty());
}