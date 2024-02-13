import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../model/movement_response_model.dart';
import '../../repository/movement_repo.dart';
import 'movement_tab_state.dart';

class MovementTabCubit extends Cubit<MovementTabState> {
  MovementTabCubit() : super(InitialMovementTabState());

  Future<void> initLoad(TableViewFormModel form) async {
    try {
      MovementResponseModel movementResponse;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      emit(InitialMovementTabState());
      emit(LoadingMovementTabState());
      movementResponse = await MovementRepo().fetchMovements(form.finder.text,
          rangeMax: limit - 1, rangeMin: 0);
      countReg = movementResponse.count;
      form.currentPage = 1;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      emit(LoadedMovementTabState());
    } catch (e) {
      emit(ErrorMovementTabState(error: e.toString()));
    }
  }

  Future<void> load(TableViewFormModel form) async {
    try {
      final int countReg;
      final int rangeMin;
      final int rangeMax;
      final int limit = TableViewFormModel.rows50;
      MovementResponseModel movementResponse;
      emit(InitialMovementTabState());
      emit(LoadingMovementTabState());
      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;
      movementResponse = await MovementRepo().fetchMovements(form.finder.text,
          rangeMax: rangeMax, rangeMin: rangeMin);
      countReg = movementResponse.count;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      emit(LoadedMovementTabState());
    } catch (e) {
      emit(ErrorMovementTabState(error: e.toString()));
    }
  }
}