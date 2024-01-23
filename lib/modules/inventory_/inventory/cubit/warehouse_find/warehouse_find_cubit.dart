import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_find.dart';
import '../../../../../utilities/widgets/drawer_find.dart';
import '../../model/warehouse_model.dart';
import '../../repository/warehouses_repo.dart';

class WarehouseFindCubit extends Cubit<DrawerFindState> {
  WarehouseFindCubit() : super(InitialDrawerFindState());

  Future<void> load(String find) async {
    List<WarehouseModel> warehouseDB;
    List<DataFind> dataList = [];
    DataFind data;
    try {
      emit(InitialDrawerFindState());
      emit(LoadingDrawerFindState());
      warehouseDB = await WarehousesRepo().fetchWarehouseIlike(find);
      for (var warehouse in warehouseDB) {
        data = DataFind(id: warehouse.id.toString(), description: warehouse.name, data: warehouse);
        dataList.add(data);
      }
      emit(LoadedDrawerFindState(dataList: dataList, valuesList: const []));
    } catch (e) {
      emit(InitialDrawerFindState());
      emit(ErrorDrawerFindState(error: e.toString()));
    }
  }
}