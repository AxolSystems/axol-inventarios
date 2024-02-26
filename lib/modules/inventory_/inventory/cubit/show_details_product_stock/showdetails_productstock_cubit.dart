import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/inventory_model.dart';
import '../../../../../models/inventory_row_model.dart';
import '../../../product/model/product_model.dart';
import '../../repository/inventory_repo.dart';
import '../../../product/repository/product_repo.dart';
import 'showdetails_productstock_state.dart';

class ShowDetailsProductStockCubit extends Cubit<ShowDetailsProductStock> {
  ShowDetailsProductStockCubit() : super(InitialState());

  Future<void> openDetails(String code, String inventoryName) async {
    //Emit estado para abrir detelles del producto y enviar InventoryRowModel.
    try {
      InventoryModel? inventoryDB;
      ProductModel? productDB;
      InventoryRowModel? inventoryRow;

      emit(InitialState());
      emit(OpenDetailsLoadingState());

      inventoryDB = await InventoryRepo().fetchRowByCode(code, inventoryName);
      productDB = await ProductRepo().fetchProductByCode(code);

      if (productDB != null) {
        if (inventoryDB == null) {
          inventoryRow = InventoryRowModel(product: productDB, stock: 0);
        } else {
          inventoryRow =
              InventoryRowModel(product: productDB, stock: inventoryDB.stock);
        }
      } else {
        inventoryRow = null;
      }
      emit(OpenDetailsLoadedState(inventoryRow: inventoryRow));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
