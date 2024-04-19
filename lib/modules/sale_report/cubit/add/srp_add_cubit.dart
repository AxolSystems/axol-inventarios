import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/data_response_model.dart';
import '../../../../models/inventory_row_model.dart';
import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../inventory_/inventory/repository/inventory_repo.dart';
import '../../../user/model/user_mdoel.dart';
import '../../../user/repository/user_repo.dart';
import '../../model/salereport_model.dart';
import '../../model/srp_add_form_model.dart';
import '../../repository/salereport_repo.dart';
import 'srp_add_state.dart';

class SrpAddCubit extends Cubit<SrpAddState> {
  SrpAddCubit() : super(InitialSrpAddState());

  Future<void> initLoad(WarehouseModel warehouse, SrpAddFormModel form, SrpAddSubState subState, [SaleReportModel? reportEdit]) async {
    try {
      emit(InitialSrpAddState());
      emit(LoadingSrpAddState());

      List<InventoryRowModel> inventoryRowList = [];
      DataResponseModel dataResponse;
      List<dynamic> dynamicList;

      dataResponse =
          await InventoryRepo().fetchInventoryList('', warehouse.name);

      dynamicList = dataResponse.dataList;
      if (dynamicList is List<InventoryRowModel>) {
        inventoryRowList = dynamicList;
        inventoryRowList
            .sort((a, b) => a.product.code.compareTo(b.product.code));
      }

      form.inventoryList = inventoryRowList;
      form.warehouse = warehouse;
      if (subState == SrpAddSubState.add) {
        form.dateTime = DateTime.now();
      } else if (subState == SrpAddSubState.edit) {
        form.dateTime = reportEdit!.date;
        form.note = TextEditingController(text: reportEdit.note);
        form.saleReportList = reportEdit.reportRows;
      }
      

      emit(LoadedSrpAddState());
    } catch (e) {
      emit(ErrorSrpAddState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSrpAddState());
      emit(LoadingSrpAddState());

      emit(LoadedSrpAddState());
    } catch (e) {
      emit(ErrorSrpAddState(error: e.toString()));
    }
  }

  Future<void> save(SrpAddFormModel form, SrpAddSubState subState, [SaleReportModel? reportEdit]) async {
    try {
      emit(InitialSrpAddState());
      emit(LoadingSrpAddState());
      SaleReportModel saleReport;
      int id;
      UserModel user;

      if (form.saleReportList.isEmpty) {
        emit(const ErrorSrpAddState(error: 'Agregue al menos un producto.'));
        return;
      }

      user = await LocalUser().getLocalUser();

      if (subState == SrpAddSubState.add) {
        id = await SaleReportRepo.fetchAvailableId();
        saleReport = SaleReportModel(
          id: id,
          date: form.dateTime,
          reportRows: form.saleReportList,
          warehouse: form.warehouse,
          note: form.note.text,
          user: user.id,
        );
        await SaleReportRepo.insert(saleReport);
      } else if (subState == SrpAddSubState.edit) {
        saleReport = SaleReportModel(
          id: reportEdit?.id ?? -1,
          date: form.dateTime,
          reportRows: form.saleReportList,
          warehouse: form.warehouse,
          note: form.note.text,
          user: user.id,
        );
        await SaleReportRepo.update(saleReport, reportEdit?.id ?? -1);
      }

      emit(SavedSrpAddState());
      emit(LoadedSrpAddState());
    } catch (e) {
      emit(ErrorSrpAddState(error: e.toString()));
    }
  }
}

class SrpAddForm extends Cubit<SrpAddFormModel> {
  SrpAddForm() : super(SrpAddFormModel.empty());
}
