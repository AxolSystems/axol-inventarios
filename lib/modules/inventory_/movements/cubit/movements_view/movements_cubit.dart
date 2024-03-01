import 'package:axol_inventarios/modules/inventory_/movements/repository/movement_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../model/movement_filter_model.dart';
import '../../model/movement_response_model.dart';
import 'movements_state.dart';

class MovementsCuibit extends Cubit<MovementsState> {
  MovementsCuibit() : super(InitialState());

  Future<void> loadList() async {
    try {
      MovementFilterModel filters = MovementFilterModel.empty();
      MovementResponseModel movements;
      emit(InitialState());
      emit(LoadingState(
          filters: filters,
          finder: const TextfieldModel(text: '', position: 0),
          mode: 0));
      //Obtener lista de movimientos de base de datos
      movements = await MovementRepo().fetchMovements(filter: filters);
      emit(LoadedState(
        movements: movements.movementList,
        finder: const TextfieldModel(text: '', position: 0),
        filters: filters,
        mode: 0,
      ));
      //emit(EditState());
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> filterMode(
      MovementFilterModel filters, TextfieldModel finder) async {
    try {
      MovementResponseModel movements;
      emit(InitialState());
      emit(LoadingState(finder: finder, filters: filters, mode: 0));
      movements = await MovementRepo().fetchMovements(filter: filters);
      emit(LoadedState(
        movements: movements.movementList,
        finder: finder,
        filters: filters,
        mode: 0,
      ));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> historyMode(
      MovementFilterModel filters, TextfieldModel finder) async {
    try {
      MovementResponseModel movements;
      emit(InitialState());
      emit(LoadingState(finder: finder, filters: filters, mode: 1));
      movements = await MovementRepo().fetchMovements(filter: filters);
      emit(LoadedState(
        movements: movements.movementList,
        finder: finder,
        filters: filters,
        mode: 1,
      ));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
