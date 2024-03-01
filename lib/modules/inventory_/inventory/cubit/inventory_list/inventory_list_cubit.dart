import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_response_model.dart';
import '../../../../../models/inventory_row_model.dart';
import '../../model/warehouse_model.dart';
import '../../repository/inventory_repo.dart';
import 'inventory_list_state.dart';

class InventoryListCubit extends Cubit<InventoryListState> {
  InventoryListCubit() : super(InitialInventoryListState());

  Future<void> initLoad(WarehouseModel warehouse) async {
    try {
      emit(InitialInventoryListState());
      emit(LoadingInventoryListState());
    
      DataResponseModel dataResponse;
      List<InventoryRowModel> inventoryRowList;

      dataResponse = await InventoryRepo().fetchInventoryList(warehouse.name, '');
      inventoryRowList = dataResponse as List<InventoryRowModel>;

      emit(LoadedInventoryListState(inventoryRowList: inventoryRowList));
    } catch (e) {
      emit(ErrorInventoryListState(error: e.toString()));
    }
  }

  Future<void> load(WarehouseModel warehouse, String find) async {
    try {
      emit(InitialInventoryListState());
      emit(LoadingInventoryListState());

      DataResponseModel dataResponse;
      List<InventoryRowModel> inventoryRowList;

      dataResponse = await InventoryRepo().fetchInventoryList(warehouse.name, find);
      inventoryRowList = dataResponse as List<InventoryRowModel>;

      emit(LoadedInventoryListState(inventoryRowList: inventoryRowList));
    } catch (e) {
      emit(ErrorInventoryListState(error: e.toString()));
    }
  }
}