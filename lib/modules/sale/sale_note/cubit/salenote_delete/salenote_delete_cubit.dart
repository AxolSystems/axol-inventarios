import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/sale_note_model.dart';
import '../../repository/sale_note_repo.dart';
import 'salenote_delete_state.dart';

class SaleNoteDeleteCubit extends Cubit<SaleNoteDeleteState> {
  SaleNoteDeleteCubit() : super(InitialSaleNoteDeleteState());

  Future<void> load() async {
    try {
      emit(InitialSaleNoteDeleteState());
      emit(LoadedSaleNoteDeleteState());
    } catch (e) {
      emit(InitialSaleNoteDeleteState());
      emit(ErrorSaleNoteDeleteState(error: e.toString()));
    }
  }
  
  Future<void> deleteCustomer(SaleNoteModel saleNote) async {
    try {
      emit(InitialSaleNoteDeleteState());
      emit(LoadingSaleNoteDeleteState());
      await SaleNoteRepo().delete(saleNote);
      emit(CloseSaleNoteDeleteState());
    } catch (e) {
      emit(InitialSaleNoteDeleteState());
      emit(ErrorSaleNoteDeleteState(error: e.toString()));
    }
  }
}