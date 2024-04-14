import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/data_response_model.dart';
import '../../../../models/inventory_row_model.dart';
import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../inventory_/inventory/repository/inventory_repo.dart';
import '../../model/srp_add_form_model.dart';
import 'srp_add_state.dart';

class SrpAddCubit extends Cubit<SrpAddState> {
  SrpAddCubit() : super(InitialSrpAddState());

  Future<void> initLoad(WarehouseModel warehouse, SrpAddFormModel form) async {
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
      form.dateTime = DateTime.now();

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

  Future<void> save(SrpAddFormModel form) async {
    try {
      emit(InitialSrpAddState());
      emit(LoadingSrpAddState());
      //WaybillListModel waybillList;
      int id;

      if (form.saleReportList .isEmpty) {
        emit(const ErrorSrpAddState(error: 'Agregue al menos un producto.'));
        return;
      }

      /*id = await WaybillRepo.fetchAvailableId();
      waybillList = WaybillListModel(
        id: id,
        date: DateTime.now(),
        list: form.waybillList,
        warehouse: form.warehouse,
      );
      await WaybillRepo.insert(waybillList);*/

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