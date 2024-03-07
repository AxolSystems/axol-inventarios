import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/warehouse_model.dart';
import '../../repository/warehouses_repo.dart';
import 'warehouse_tab_state.dart';

class WarehouseTabCubit extends Cubit<WarehouseTabState> {
  WarehouseTabCubit() : super(InitialWarehouseTabState());

  Future<void> initLoad() async {
    try {
      emit(InitialWarehouseTabState());
      emit(LoadingWarehouseTabState());

      List<WarehouseModel> warehouseList;
      warehouseList = await WarehousesRepo().fetchAllWarehouses();
      warehouseList.insert(0, WarehouseModel.multi());

      emit(LoadedWarehouseTabState(warehouseList: warehouseList));
    } catch (e) {
      emit(ErrorWarehouseTabState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialWarehouseTabState());
      emit(LoadingWarehouseTabState());

      List<WarehouseModel> warehouseList;
      warehouseList = await WarehousesRepo().fetchAllWarehouses();

      emit(LoadedWarehouseTabState(warehouseList: warehouseList));
    } catch (e) {
      emit(ErrorWarehouseTabState(error: e.toString()));
    }
  }
}
