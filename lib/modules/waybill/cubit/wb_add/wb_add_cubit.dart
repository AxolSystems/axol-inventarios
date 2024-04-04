import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/data_response_model.dart';
import '../../../../models/inventory_row_model.dart';
import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../inventory_/inventory/repository/inventory_repo.dart';
import '../../model/wb_add_form_model.dart';
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
        inventoryRowList.sort((a, b) => a.product.code.compareTo(b.product.code));
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
}

class WbAddForm extends Cubit<WbAddFormModel> {
  WbAddForm() : super(WbAddFormModel.empty());
}