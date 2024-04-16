import 'package:axol_inventarios/models/data_response_model.dart';
import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:axol_inventarios/modules/user/repository/user_repo.dart';
import 'package:axol_inventarios/utilities/widgets/table_view/tableview_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/salereport_model.dart';
import '../../model/srp_doclist_form_model.dart';
import '../../repository/salereport_file_repo.dart';
import '../../repository/salereport_repo.dart';
import 'srp_doclist_tab_state.dart';

class SrpDoclistCubit extends Cubit<SrpDoclistState> {
  SrpDoclistCubit() : super(InitialSrpDoclistState());

  Future<void> initLoad(SrpDoclistFormModel form) async {
    try {
      emit(InitialSrpDoclistState());
      emit(LoadingSrpDoclistState());

      DataResponseModel dataResponse;
      UserModel user;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      List<dynamic> dynamicList;

      //Identifica el tipo de usuario
      user = await LocalUser().getLocalUser();

      //Consulta listas
      dataResponse = await SaleReportRepo.fetchSaleReportList(
        rangeMax: limit - 1,
        rangeMin: 0,
        user: user,
      );
      countReg = dataResponse.count;

      form.currentPage = 1;
      form.totalPages = (countReg / limit).ceil();
      form.totalReg = countReg;
      dynamicList = dataResponse.dataList;
      if (dynamicList is List<SaleReportModel>) {
        form.saleReportList = dynamicList;
      }

      emit(LoadedSrpDoclistState());
    } catch (e) {
      emit(ErrorSrpDoclistState(error: e.toString()));
    }
  }

  Future<void> load(SrpDoclistFormModel form) async {
    try {
      emit(InitialSrpDoclistState());
      emit(LoadingSrpDoclistState());

      DataResponseModel dataResponse;
      UserModel user;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      final int rangeMin;
      final int rangeMax;
      List<dynamic> dynamicList;

      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;

      //Identifica el tipo de usuario
      user = await LocalUser().getLocalUser();

      //Consulta listas
      dataResponse = await SaleReportRepo.fetchSaleReportList(
        user: user,
        rangeMax: rangeMax,
        rangeMin: rangeMin,
      );
      countReg = dataResponse.count;

      form.currentPage = 1;
      form.totalPages = (countReg / limit).ceil();
      form.totalReg = countReg;
      dynamicList = dataResponse.dataList;
      if (dynamicList is List<SaleReportModel>) {
        form.saleReportList = dynamicList;
      }

      emit(LoadedSrpDoclistState());
    } catch (e) {
      emit(ErrorSrpDoclistState(error: e.toString()));
    }
  }

  Future<void> saveCsv(SaleReportModel report) async {
    try {
      emit(InitialSrpDoclistState());
      emit(LoadingSrpDoclistState());

      await SaleReportCsv.srpCsvSave(report);

      emit(LoadedSrpDoclistState());
    } catch (e) {
      emit(ErrorSrpDoclistState(error: e.toString()));
    }
  }

  /*Future<void> openDetails(WaybillListModel waybill) async {
    try {
      emit(InitialSrpDoclistState());
      emit(LoadingSrpDoclistState());
      List<InventoryRowModel> waybillList;
      WaybillListModel upWaybill;

      waybillList = await WaybillRepo.fetchWaybill(waybill.id);
      upWaybill = WaybillListModel(
        id: waybill.id,
        date: waybill.date,
        list: waybillList,
        warehouse: waybill.warehouse,
      );

      emit(OpenDetailsSrpDoclistState(saleReport: ));
      emit(LoadedSrpDoclistState());
    } catch (e) {
      emit(ErrorSrpDoclistState(error: e.toString()));
    }
  }*/
}

class SrpDoclistForm extends Cubit<SrpDoclistFormModel> {
  SrpDoclistForm() : super(SrpDoclistFormModel.empty());
}