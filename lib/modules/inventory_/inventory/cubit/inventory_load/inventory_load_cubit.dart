import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/inventory_row_model.dart';
import '../../../product/model/product_response_model.dart';
import '../../../product/repository/product_repo.dart';
import '../../repository/inventory_repo.dart';
import 'inventory_load_state.dart';

class InventoryLoadCubit extends Cubit<InventoryLoadState> {
  InventoryLoadCubit() : super(InitialState());

  Future<void> loadInventory(String inventoryName, String filter) async {
    try {
      emit(InitialState());
      emit(LoadingState());
      final List<InventoryRowModel> inventoryList =
          await InventoryRepo().getInventoryList(inventoryName, filter);
      emit(LoadedInventory(inventoryList: inventoryList));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> loadProducts() async {
    try {
      emit(InitialState());
      emit(LoadingState());
      final List<ProductModel> productList = await ProductRepo().fetchAllProducts();
      emit(LoadedProducts(productList: productList));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> findProducts(String filter) async {
    try {
      emit(InitialState());
      emit(LoadingState());
      final ProductResponseModel productList = await ProductRepo().fetchProductFinder(filter);
      emit(LoadedProducts(productList: productList.productList));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
