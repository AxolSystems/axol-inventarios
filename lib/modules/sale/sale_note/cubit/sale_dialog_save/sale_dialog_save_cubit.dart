import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/sale_note_model.dart';
import '../../model/sale_product_model.dart';
import '../../repository/sale_file_repo.dart';
import 'sale_dialog_save_state.dart';

class SaleDialogSaveCubit extends Cubit<SaleDialogSaveState> {
  SaleDialogSaveCubit() : super(InitialSaleDialogSaveState());

  Future<void> load() async {
    try {
      emit(InitialSaleDialogSaveState());
      emit(LoadingSaleDialogSaveState());

      emit(LoadedSaleDialogSaveState());
    } catch (e) {
      emit(InitialSaleDialogSaveState());
      emit(ErrorSaleDialogSaveState(error: e.toString()));
    }
  }

  Future<void> downloadPdf(SaleNoteModel saleNote,
      List<SaleProductModel> productList, int saleType) async {
    try {
      emit(InitialSaleDialogSaveState());
      emit(LoadingSaleDialogSaveState());
      //await SaleFileRepo.saleNotePdf(saleNote, productList, saleType);
      emit(LoadedSaleDialogSaveState());
    } catch (e) {
      emit(InitialSaleDialogSaveState());
      emit(ErrorSaleDialogSaveState(error: e.toString()));
    }
  }
}