import 'package:axol_inventarios/modules/sale/sale_note/model/salenote_filter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/sale_note_model.dart';
import '../../repository/sale_note_repo.dart';
import '../../repository/sale_referral_repo.dart';
import 'salenote_tab_state.dart';

class SaleNoteTabCubit extends Cubit<SaleNoteTabState> {
  SaleNoteTabCubit() : super(InitialSaleNoteState());

  Future<void> load(String find, int saleType) async {
    List<SaleNoteModel> salenoteListDB = [];
    try {
      emit(InitialSaleNoteState());
      emit(LoadingSaleNoteState());
      if (saleType == 0) {
        salenoteListDB =
            await SaleNoteRepo().fetchNotes(SaleNoteFilterModel.empty(), find);
      }
      if (saleType == 1) {
        salenoteListDB =
            await SaleReferralRepo().fetchReferral(SaleNoteFilterModel.empty(), find);
      }
      emit(LoadedSaleNoteState(salenoteList: salenoteListDB));
    } catch (e) {
      emit(InitialSaleNoteState());
      emit(ErrorSalenoteState(error: e.toString()));
    }
  }

  Future<void> initLoad(int saleType) async {
    try {
      emit(InitialSaleNoteState());
      emit(LoadingSaleNoteState());
      List<SaleNoteModel> notesDB = [];
      //Nota de venta
      if (saleType == 0) {
        notesDB =
            await SaleNoteRepo().fetchNotes(SaleNoteFilterModel.empty(), '');
      }
      //Remision
      if (saleType == 1) {
        notesDB = await SaleReferralRepo()
            .fetchReferral(SaleNoteFilterModel.empty(), '');
      }
      emit(LoadedSaleNoteState(salenoteList: notesDB));
    } catch (e) {
      emit(ErrorSalenoteState(error: e.toString()));
    }
  }

  Future<void> reloadList(String finder, SaleNoteFilterModel filter) async {
    try {
      List<SaleNoteModel> notesDB;
      emit(InitialSaleNoteState());
      emit(LoadingSaleNoteState());
      notesDB = await SaleNoteRepo().fetchNotes(filter, finder);
      emit(LoadedSaleNoteState(salenoteList: notesDB));
    } catch (e) {
      emit(ErrorSalenoteState(error: e.toString()));
    }
  }
}
