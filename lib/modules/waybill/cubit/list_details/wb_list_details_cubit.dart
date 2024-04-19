import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/inventory_row_model.dart';
import '../../repository/waybill_file_repo.dart';
import 'wb_list_details_state.dart';

class WbListDetailsCubit extends Cubit<WbListDetailsState> {
  WbListDetailsCubit() : super(InitialWbListDetailsState());

  Future<void> initLoad() async {
    try {
      emit(InitialWbListDetailsState());
      emit(const LoadingWbListDetailsState(loadingState: LoadingWbListDetails.main));

      emit(LoadedWbListDetailsState());
    } catch (e) {
      emit(ErrorWbListDetailsState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialWbListDetailsState());
      emit(const LoadingWbListDetailsState(loadingState: LoadingWbListDetails.main));

      emit(LoadedWbListDetailsState());
    } catch (e) {
      emit(ErrorWbListDetailsState(error: e.toString()));
    }
  }

  Future<void> saveCsv(List<InventoryRowModel> waybill) async {
    try {
      emit(InitialWbListDetailsState());
      emit(const LoadingWbListDetailsState(loadingState: LoadingWbListDetails.downCsv));

      await WaybillCsv.waybillCsvSave(waybill);

      emit(LoadedWbListDetailsState());
    } catch (e) {
      emit(ErrorWbListDetailsState(error: e.toString()));
    }
  }
}