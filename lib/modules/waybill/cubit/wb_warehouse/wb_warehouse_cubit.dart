import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../inventory_/inventory/repository/warehouses_repo.dart';
import '../../../user/model/user_model.dart';
import '../../../user/repository/user_repo.dart';
import 'wb_warehouse_state.dart';

class WbWarehouseTabCubit extends Cubit<WbWarehouseTabState> {
  WbWarehouseTabCubit() : super(InitialWbWarehouseTabState());

  Future<void> initLoad() async {
    try {
      emit(InitialWbWarehouseTabState());
      emit(LoadingWbWarehouseTabState());
      List<WarehouseModel> warehouseList = [];
      UserModel user;

      user = await LocalUser().getLocalUser();
      if (user.rol == UserModel.rolAdmin) {
        warehouseList = await WarehousesRepo().fetchAllWarehouses();
      } else if (user.rol == UserModel.rolVendor) {
        warehouseList = await WarehousesRepo().fetchWarehouseManager(user.id);
      }
      emit(LoadedWbWarehouseTabState(warehouseList: warehouseList));
    } catch (e) {
      emit(ErrorWbWarehouseTabState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialWbWarehouseTabState());
      emit(LoadingWbWarehouseTabState());

      List<WarehouseModel> warehouseList;
      UserModel user;

      user = await LocalUser().getLocalUser();
      warehouseList = await WarehousesRepo().fetchWarehouseManager(user.id);

      emit(LoadedWbWarehouseTabState(warehouseList: warehouseList));
    } catch (e) {
      emit(ErrorWbWarehouseTabState(error: e.toString()));
    }
  }
}
