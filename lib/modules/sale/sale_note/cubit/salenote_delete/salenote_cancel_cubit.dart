import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/sale_note_model.dart';
import '../../repository/sale_note_repo.dart';
import 'salenote_cancel_state.dart';

class SaleNoteCancelCubit extends Cubit<SaleNoteCancelState> {
  SaleNoteCancelCubit() : super(InitialSaleNoteDeleteState());

  Future<void> load() async {
    try {
      emit(InitialSaleNoteDeleteState());
      emit(LoadedSaleNoteDeleteState());
    } catch (e) {
      emit(InitialSaleNoteDeleteState());
      emit(ErrorSaleNoteCancelState(error: e.toString()));
    }
  }
  
  Future<void> cancelSaleNote(SaleNoteModel saleNote) async {
    try {
      emit(InitialSaleNoteDeleteState());
      emit(LoadingSaleNoteCancelState());
      await SaleNoteRepo().cancelNote(saleNote);
      emit(CloseSaleNoteCancelState());
    } catch (e) {
      emit(InitialSaleNoteDeleteState());
      emit(ErrorSaleNoteCancelState(error: e.toString()));
    }
  }
}