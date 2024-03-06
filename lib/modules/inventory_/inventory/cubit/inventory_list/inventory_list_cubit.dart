import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_response_model.dart';
import '../../../../../models/inventory_row_model.dart';
import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../model/warehouse_model.dart';
import '../../repository/inventory_repo.dart';
import 'inventory_list_state.dart';

class InventoryListCubit extends Cubit<InventoryListState> {
  InventoryListCubit() : super(InitialInventoryListState());

  Future<void> initLoad(
      WarehouseModel warehouse, TableViewFormModel form) async {
    try {
      emit(InitialInventoryListState());
      emit(LoadingInventoryListState());

      final int countReg;
      final int limit = TableViewFormModel.rows50;
      DataResponseModel dataResponse;
      List<InventoryRowModel> inventoryRowList = [];

      dataResponse = await InventoryRepo().fetchInventoryList(
        '',
        warehouse.name,
        rangeMin: 0,
        rangeMax: limit - 1,
      );
      
      inventoryRowList = dataResponse.dataList as List<InventoryRowModel>;
      countReg = dataResponse.count;
      form.currentPage = 1;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      form.filter = {};
      emit(LoadedInventoryListState(inventoryRowList: inventoryRowList));
    } catch (e) {
      emit(ErrorInventoryListState(error: e.toString()));
    }
  }

  Future<void> load(WarehouseModel warehouse, String find) async {
    try {
      emit(InitialInventoryListState());
      emit(LoadingInventoryListState());
      final int countReg;
      final int rangeMin;
      final int rangeMax;
      final int limit = TableViewFormModel.rows50;
      DataResponseModel dataResponse;
      List<InventoryRowModel> inventoryRowList;

      dataResponse =
          await InventoryRepo().fetchInventoryList(warehouse.name, find);
      inventoryRowList = dataResponse as List<InventoryRowModel>;

      emit(LoadedInventoryListState(inventoryRowList: inventoryRowList));
    } catch (e) {
      emit(ErrorInventoryListState(error: e.toString()));
    }
  }
}
