import 'package:axol_inventarios/modules/sale/sale_note/model/salenote_filter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_response_model.dart';
import '../../model/sale_note_model.dart';
import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../repository/sale_note_repo.dart';
import '../../repository/sale_referral_repo.dart';
import 'salenote_tab_state.dart';

class SaleNoteTabCubit extends Cubit<SaleNoteTabState> {
  SaleNoteTabCubit() : super(InitialSaleNoteState());

  Future<void> load(
      int saleType, TableViewFormModel form, bool resetPage) async {
    List<SaleNoteModel> salenoteListDB = [];
    DataResponseModel dataResponse;
    final int countReg;
    final int rangeMin;
    final int rangeMax;
    final int limit = TableViewFormModel.rows50;
    final String find = form.finder.text;
    try {
      emit(InitialSaleNoteState());
      emit(LoadingSaleNoteState());
      if (resetPage) {
        form.currentPage = 1;
      }
      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;
      if (saleType == 0) {
        dataResponse = await SaleNoteRepo().fetchNotes(
            SaleFilterModel.range(rangeMin: rangeMin, rangeMax: rangeMax),
            find);
        countReg = dataResponse.count;
        if (dataResponse.dataList is List<SaleNoteModel>) {
          salenoteListDB = dataResponse.dataList as List<SaleNoteModel>;
        }
      } else if (saleType == 1) {
        dataResponse = await SaleReferralRepo().fetchReferral(
            SaleFilterModel.range(rangeMin: rangeMin, rangeMax: rangeMax),
            find);
        countReg = dataResponse.count;
        if (dataResponse.dataList is List<SaleNoteModel>) {
          salenoteListDB = dataResponse.dataList as List<SaleNoteModel>;
        }
      } else {
        countReg = 0;
      }
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      emit(LoadedSaleNoteState(salenoteList: salenoteListDB));
    } catch (e) {
      emit(InitialSaleNoteState());
      emit(ErrorSalenoteState(error: e.toString()));
    }
  }

  Future<void> initLoad(int saleType, TableViewFormModel form) async {
    try {
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      emit(InitialSaleNoteState());
      emit(LoadingSaleNoteState());
      List<SaleNoteModel> notesDB = [];
      DataResponseModel dataResponse;
      //Nota de venta
      if (saleType == 0) {
        dataResponse = await SaleNoteRepo().fetchNotes(
            SaleFilterModel.range(rangeMin: 0, rangeMax: limit - 1), '');
        countReg = dataResponse.count;
        if (dataResponse.dataList is List<SaleNoteModel>) {
          notesDB = dataResponse.dataList as List<SaleNoteModel>;
        }
      } else if (saleType == 1) {
        dataResponse = await SaleReferralRepo().fetchReferral(
            SaleFilterModel.range(rangeMin: 0, rangeMax: limit - 1), '');
        countReg = dataResponse.count;
        if (dataResponse.dataList is List<SaleNoteModel>) {
          notesDB = dataResponse.dataList as List<SaleNoteModel>;
        }
      } else {
        countReg = 0;
      }
      form.currentPage = 1;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;

      emit(LoadedSaleNoteState(salenoteList: notesDB));
    } catch (e) {
      emit(ErrorSalenoteState(error: e.toString()));
    }
  }
}
