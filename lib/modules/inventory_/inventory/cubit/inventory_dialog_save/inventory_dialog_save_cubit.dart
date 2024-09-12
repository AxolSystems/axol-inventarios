import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/report_inventory_move_model.dart';
import '../../repository/inventory_file_repo.dart';
import 'inventory_dialog_save_state.dart';

class InventoryDialogSaveCubit extends Cubit<InventoryDialogSaveState> {
  InventoryDialogSaveCubit() : super(InitialInventoryDialogSaveState());

  Future<void> load() async {
    try {
      emit(InitialInventoryDialogSaveState());
      emit(LoadingInventoryDialogSaveState());

      emit(LoadedInventoryDialogSaveState());
    } catch (e) {
      emit(InitialInventoryDialogSaveState());
      emit(ErrorInventoryDialogSaveState(error: e.toString()));
    }
  }

  Future<void> downloadTransferPdf(ReportInventoryMoveModel dataReport) async {
    try {
      emit(InitialInventoryDialogSaveState());
      emit(LoadingInventoryDialogSaveState());
      //await InventoryPdfRepo.transferPdf(dataReport);
      emit(LoadedInventoryDialogSaveState());
    } catch (e) {
      emit(InitialInventoryDialogSaveState());
      emit(ErrorInventoryDialogSaveState(error: e.toString()));
    }
  }

  Future<void> downloadSingleMovePdf(ReportInventoryMoveModel dataReport) async {
    try {
      emit(InitialInventoryDialogSaveState());
      emit(LoadingInventoryDialogSaveState());
      //await InventoryPdfRepo.singleMove(dataReport);
      emit(LoadedInventoryDialogSaveState());
    } catch (e) {
      emit(InitialInventoryDialogSaveState());
      emit(ErrorInventoryDialogSaveState(error: e.toString()));
    }
  }
}