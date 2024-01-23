import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_find.dart';
import '../../../../../models/inventory_model.dart';
import '../../../../../models/inventory_row_model.dart';
import '../../../../../utilities/widgets/drawer_find.dart';
import '../../../inventory/model/warehouse_model.dart';
import '../../../inventory/repository/inventory_repo.dart';
import '../../model/product_model.dart';
import '../../repository/product_repo.dart';

class ProductFindCubit extends Cubit<DrawerFindState> {
  ProductFindCubit() : super(InitialDrawerFindState());

  Future<void> load(String find, WarehouseModel warehouse) async {
    //List<ProductModel> productsDB;
    List<InventoryRowModel> inventoryDB;
    List<DataFindValues> valuesList = [];
    DataFindValues data;
    try {
      emit(InitialDrawerFindState());
      emit(LoadingDrawerFindState());
      //productsDB = await ProductRepo().fetchProductFinder(find);
      inventoryDB =
          await InventoryRepo().getInventoryList(warehouse.name, find);
      for (var inventory in inventoryDB) {
        data = DataFindValues(values: [
          inventory.product.code,
          inventory.product.description,
          inventory.stock.toString()
        ], data: inventory);
        valuesList.add(data);
      }
      emit(LoadedDrawerFindState(valuesList: valuesList, dataList: const []));
    } catch (e) {
      emit(InitialDrawerFindState());
      emit(ErrorDrawerFindState(error: e.toString()));
    }
  }
}
