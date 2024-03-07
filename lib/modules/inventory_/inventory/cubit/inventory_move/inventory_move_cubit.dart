import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/inventory_move/inventory_move_model.dart';
import 'inventory_move_state.dart';

class InventoryMoveCubit extends Cubit<InventoryMoveState> {
  InventoryMoveCubit() : super(InitialInventoryMoveState());

  Future<void> initLoad(InventoryMoveModel form) async {
    try {
      emit(InitialInventoryMoveState());
      emit(LoadingInventoryMoveState());

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