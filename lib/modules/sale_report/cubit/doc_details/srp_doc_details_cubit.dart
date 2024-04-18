import 'package:axol_inventarios/modules/sale_report/model/salereport_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/salereport_file_repo.dart';
import 'srp_doc_details_state.dart';

class SrpDocDetailsCubit extends Cubit<SrpDocDetailsState> {
  SrpDocDetailsCubit() : super(InitialSrpDocDetailsState());

  Future<void> initLoad() async {
    try {
      emit(InitialSrpDocDetailsState());
      emit(LoadingSrpDocDetailsState());

      emit(LoadedSrpDocDetailsState());
    } catch (e) {
      emit(ErrorSrpDocDetailsState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSrpDocDetailsState());
      emit(LoadingSrpDocDetailsState());

      emit(LoadedSrpDocDetailsState());
    } catch (e) {
      emit(ErrorSrpDocDetailsState(error: e.toString()));
    }
  }

  Future<void> saveCsv(SaleReportModel report) async {
    try {
      emit(InitialSrpDocDetailsState());
      emit(LoadingSrpDocDetailsState());

      await SaleReportCsv.srpCsvSave(report);

      emit(LoadedSrpDocDetailsState());
    } catch (e) {
      emit(ErrorSrpDocDetailsState(error: e.toString()));
    }
  }
}