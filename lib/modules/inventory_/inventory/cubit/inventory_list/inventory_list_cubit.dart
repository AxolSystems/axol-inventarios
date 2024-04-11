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

      if (warehouse.id == -2) {
        dataResponse = await InventoryRepo().fetchInventoryListMulti(
          '',
          warehouse.name,
          rangeMin: 0,
          rangeMax: limit - 1,
        );
      } else {
        dataResponse = await InventoryRepo().fetchInventoryList(
          '',
          warehouse.name,
          rangeMin: 0,
          rangeMax: limit - 1,
        );
      }

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

  Future<void> load(WarehouseModel warehouse, TableViewFormModel form, bool resetPage) async {
    try {
      emit(InitialInventoryListState());
      emit(LoadingInventoryListState());
      final int countReg;
      final int rangeMin;
      final int rangeMax;
      final int limit = TableViewFormModel.rows50;
      DataResponseModel dataResponse;
      List<InventoryRowModel> inventoryRowList;

      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;
      if (warehouse.id == -2) {
        dataResponse = await InventoryRepo().fetchInventoryListMulti(
          form.finder.text,
          warehouse.name,
          rangeMin: rangeMin,
          rangeMax: rangeMax,
        );
      } else {
        dataResponse = await InventoryRepo().fetchInventoryList(
          form.finder.text,
          warehouse.name,
          rangeMin: rangeMin,
          rangeMax: rangeMax,
        );
      }

      inventoryRowList = dataResponse.dataList as List<InventoryRowModel>;
      countReg = dataResponse.count;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      if (countReg > 0) {
        if (resetPage) {
          form.currentPage = 1;
        }
      } else {
        form.currentPage = 0;
      }

      emit(LoadedInventoryListState(inventoryRowList: inventoryRowList));
    } catch (e) {
      emit(ErrorInventoryListState(error: e.toString()));
    }
  }
}
