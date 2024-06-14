import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../user/model/user_model.dart';
import '../../../../user/repository/user_repo.dart';
import '../../model/warehouse_model.dart';
import '../../repository/warehouses_repo.dart';
import 'warehouse_tab_state.dart';

class WarehouseTabCubit extends Cubit<WarehouseTabState> {
  WarehouseTabCubit() : super(InitialWarehouseTabState());

  Future<void> initLoad() async {
    try {
      final UserModel user;
      List<WarehouseModel> warehouseList;
      emit(InitialWarehouseTabState());
      user = await LocalUser().getLocalUser();
      emit(LoadingWarehouseTabState());

      if (user.rol == UserModel.rolVendor) {
        warehouseList = await WarehousesRepo().fetchWarehouseManager(user.id,[1]);
      } else {
        warehouseList = await WarehousesRepo().fetchAllWarehouses();
        warehouseList.insert(0, WarehouseModel.multi());
      }

      emit(LoadedWarehouseTabState(warehouseList: warehouseList));
    } catch (e) {
      emit(ErrorWarehouseTabState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      final UserModel user;
      List<WarehouseModel> warehouseList;
      emit(InitialWarehouseTabState());
      user = await LocalUser().getLocalUser();
      emit(LoadingWarehouseTabState());

      if (user.rol == UserModel.rolVendor) {
        warehouseList = await WarehousesRepo().fetchWarehouseManager(user.id,[1]);
      } else {
        warehouseList = await WarehousesRepo().fetchAllWarehouses();
        warehouseList.insert(0, WarehouseModel.multi());
      }

      emit(LoadedWarehouseTabState(warehouseList: warehouseList));
    } catch (e) {
      emit(ErrorWarehouseTabState(error: e.toString()));
    }
  }
}
