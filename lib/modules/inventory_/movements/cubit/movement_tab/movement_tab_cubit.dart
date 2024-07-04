import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../model/movement_filter_model.dart';
import '../../model/movement_model.dart';
import '../../model/movement_response_model.dart';
import '../../repository/movement_files_repo.dart';
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
      movementResponse = await MovementRepo().fetchMovements(
          find: form.finder.text, rangeMax: limit - 1, rangeMin: 0);
      countReg = movementResponse.count;
      form.currentPage = 1;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      form.filter = {};
      emit(LoadedMovementTabState(movementList: movementResponse.movementList));
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
      MovementFilterModel filter;
      emit(InitialMovementTabState());
      emit(LoadingMovementTabState());
      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;
      filter = MovementFilterModel.mapToFilter(form.filter);
      movementResponse = await MovementRepo().fetchMovements(
          find: form.finder.text,
          rangeMax: rangeMax,
          rangeMin: rangeMin,
          filter: filter);
      countReg = movementResponse.count;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      if (form.limitPage == 0) {
        form.currentPage = 0;
      }
      emit(LoadedMovementTabState(movementList: movementResponse.movementList));
    } catch (e) {
      emit(ErrorMovementTabState(error: e.toString()));
    }
  }

  Future<void> downloadPdf(List<MovementModel> movementList) async {
    try {
      emit(InitialMovementTabState());
      emit(LoadingMovementTabState());
      await MovementPdfRepo.movementPdfSave(movementList);
      emit(LoadedMovementTabState(movementList: movementList));
    } catch (e) {
      emit(ErrorMovementTabState(error: e.toString()));
    }
  }

  Future<void> downloadCsv(List<MovementModel> movementList) async {
    try {
      emit(InitialMovementTabState());
      emit(LoadingMovementTabState());
      await MovementCsvRepo.movementCsvSave(movementList);
      emit(LoadedMovementTabState(movementList: movementList));
    } catch (e) {
      emit(ErrorMovementTabState(error: e.toString()));
    }
  }
}
