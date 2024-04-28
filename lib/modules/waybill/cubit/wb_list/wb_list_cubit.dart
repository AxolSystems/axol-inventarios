import 'package:axol_inventarios/modules/waybill/model/waybill_list_model.dart';
import 'package:axol_inventarios/utilities/widgets/table_view/tableview_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/data_response_model.dart';
import '../../../../models/inventory_row_model.dart';
import '../../../user/model/user_mdoel.dart';
import '../../../user/repository/user_repo.dart';
import '../../model/wb_list_form_model.dart';
import '../../repository/waybill_file_repo.dart';
import '../../repository/waybill_repo.dart';
import 'wb_list_state.dart';

class WbListCubit extends Cubit<WbListState> {
  WbListCubit() : super(InitialWbListState());

  Future<void> initLoad(WbListFormModel form) async {
    try {
      emit(InitialWbListState());
      emit(LoadingWbListState());

      DataResponseModel dataResponse;
      UserModel user;
      int manager;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      List<dynamic> dynamicList;

      //Identifica el tipo de usuario
      user = await LocalUser().getLocalUser();
      if (user.rol == UserModel.rolAdmin || user.rol == UserModel.rolSup) {
        manager = -2;
      } else {
        manager = user.id;
      }

      //Consulta listas
      dataResponse = await WaybillRepo.fetchLists(
        manager: manager,
        rangeMax: limit - 1,
        rangeMin: 0,
      );
      countReg = dataResponse.count;

      form.currentPage = 1;
      form.totalPages = (countReg / limit).ceil();
      form.totalReg = countReg;
      dynamicList = dataResponse.dataList;
      if (dynamicList is List<WaybillListModel>) {
        form.waybillList = dynamicList;
      }

      emit(LoadedWbListState());
    } catch (e) {
      emit(ErrorWbListState(error: e.toString()));
    }
  }

  Future<void> load(WbListFormModel form) async {
    try {
      emit(InitialWbListState());
      emit(LoadingWbListState());

      DataResponseModel dataResponse;
      UserModel user;
      int manager;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      final int rangeMin;
      final int rangeMax;
      List<dynamic> dynamicList;

      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;

      //Identifica el tipo de usuario
      user = await LocalUser().getLocalUser();
      if (user.rol == UserModel.rolAdmin) {
        manager = -2;
      } else {
        manager = user.id;
      }

      //Consulta listas
      dataResponse = await WaybillRepo.fetchLists(
        manager: manager,
        rangeMax: rangeMax,
        rangeMin: rangeMin,
      );
      countReg = dataResponse.count;

      form.currentPage = 1;
      form.totalPages = (countReg / limit).ceil();
      form.totalReg = countReg;
      dynamicList = dataResponse.dataList;
      if (dynamicList is List<WaybillListModel>) {
        form.waybillList = dynamicList;
      }

      emit(LoadedWbListState());
    } catch (e) {
      emit(ErrorWbListState(error: e.toString()));
    }
  }

  Future<void> saveCsv(int id) async {
    try {
      emit(InitialWbListState());
      emit(LoadingWbListState());
      List<InventoryRowModel> waybill;

      waybill = await WaybillRepo.fetchWaybill(id);

      await WaybillCsv.waybillCsvSave(waybill);
      emit(LoadedWbListState());
    } catch (e) {
      emit(ErrorWbListState(error: e.toString()));
    }
  }

  Future<void> openDetails(WaybillListModel waybill) async {
    try {
      emit(InitialWbListState());
      emit(LoadingWbListState());
      List<InventoryRowModel> waybillList;
      WaybillListModel upWaybill;
      UserModel user;

      user = await LocalUser().getLocalUser();

      waybillList = await WaybillRepo.fetchWaybill(waybill.id);
      upWaybill = WaybillListModel(
        id: waybill.id,
        date: waybill.date,
        list: waybillList,
        warehouse: waybill.warehouse,
      );

      emit(OpenDetailsWbListState(waybillList: upWaybill, user: user));
      emit(LoadedWbListState());
    } catch (e) {
      emit(ErrorWbListState(error: e.toString()));
    }
  }
}

class WbListForm extends Cubit<WbListFormModel> {
  WbListForm() : super(WbListFormModel.empty());
}
