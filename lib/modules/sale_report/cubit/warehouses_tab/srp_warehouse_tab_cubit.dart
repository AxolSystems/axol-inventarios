import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../inventory_/inventory/repository/warehouses_repo.dart';
import '../../../user/model/user_model.dart';
import '../../../user/repository/user_repo.dart';
import 'srp_warehouse_tab_state.dart';

class SrpWarehouseTabCubit extends Cubit<SrpWarehouseTabState> {
  SrpWarehouseTabCubit() : super(InitialSrpWarehouseTabState());

  Future<void> initLoad() async {
    try {
      emit(InitialSrpWarehouseTabState());
      emit(LoadingSrpWarehouseTabState());

      List<WarehouseModel> warehouseList = [];
      UserModel user;

      user = await LocalUser().getLocalUser();
      if (user.rol == UserModel.rolAdmin) {
        warehouseList = await WarehousesRepo().fetchAllWarehouses();
      } else if (user.rol == UserModel.rolVendor) {
        warehouseList = await WarehousesRepo().fetchWarehouseManager(user.id);
      }

      emit(LoadedSrpWarehouseTabState(warehouseList: warehouseList));
    } catch (e) {
      emit(ErrorSrpWarehouseTabState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSrpWarehouseTabState());
      emit(LoadingSrpWarehouseTabState());

      List<WarehouseModel> warehouseList;
      UserModel user;

      user = await LocalUser().getLocalUser();
      warehouseList = await WarehousesRepo().fetchWarehouseManager(user.id);

      emit(LoadedSrpWarehouseTabState(warehouseList: warehouseList));
    } catch (e) {
      emit(ErrorSrpWarehouseTabState(error: e.toString()));
    }
  }
}
