import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/data_response_model.dart';
import '../../../../models/inventory_row_model.dart';
import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../inventory_/inventory/repository/inventory_repo.dart';
import '../../model/waybill_list_model.dart';
import '../../model/wb_add_form_model.dart';
import '../../repository/waybill_repo.dart';
import 'wb_add_state.dart';

class WbAddCubit extends Cubit<WbAddState> {
  WbAddCubit() : super(InitialWbAddState());

  Future<void> initLoad(WarehouseModel warehouse, WbAddFormModel form) async {
    try {
      emit(InitialWbAddState());
      emit(LoadingWbAddState());

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

      emit(LoadedWbAddState());
    } catch (e) {
      emit(ErrorWbAddState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialWbAddState());
      emit(LoadingWbAddState());

      emit(LoadedWbAddState());
    } catch (e) {
      emit(ErrorWbAddState(error: e.toString()));
    }
  }

  Future<void> save(WbAddFormModel form, {WaybillListModel? waybillEdit, int? idEdit}) async {
    try {
      emit(InitialWbAddState());
      emit(LoadingWbAddState());
      WaybillListModel waybillList;
      int id;

      if (form.waybillList.isEmpty) {
        emit(const ErrorWbAddState(error: 'Agregue al menos un producto.'));
        return;
      }

      if (waybillEdit != null && idEdit != null) {
        waybillList = WaybillListModel(
          id: idEdit,
          date: waybillEdit.date,
          list: form.waybillList,
          warehouse: form.warehouse,
        );
        await WaybillRepo.update(waybillList, idEdit);
      } else {
        id = await WaybillRepo.fetchAvailableId();
        waybillList = WaybillListModel(
          id: id,
          date: DateTime.now(),
          list: form.waybillList,
          warehouse: form.warehouse,
        );
        await WaybillRepo.insert(waybillList);
      }

      emit(SavedWbAddState());
      emit(LoadedWbAddState());
    } catch (e) {
      emit(ErrorWbAddState(error: e.toString()));
    }
  }
}

class WbAddForm extends Cubit<WbAddFormModel> {
  WbAddForm() : super(WbAddFormModel.empty());

  WbAddForm.set(WbAddFormModel form) : super(WbAddFormModel.set(form));
}
