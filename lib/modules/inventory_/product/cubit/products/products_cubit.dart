import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/product_model.dart';
import '../../../../../models/textfield_model.dart';
import '../../repository/product_repo.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(InitialState());

  Future<void> initialList() async {
    try {
      TextfieldModel initialFinder = const TextfieldModel(text: '', position: 0);
      List<ProductModel> products;
      emit(InitialState());
      emit(LoadingState(finder: initialFinder, mode: 0));
      products = await ProductRepo().fetchAllProducts();
      emit(LoadedState(products: products, finder: initialFinder, mode: 0));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> reloadList(TextfieldModel finder, int mode) async {
    try {
      List<ProductModel> products;
      emit(InitialState());
      emit(LoadingState(finder: finder, mode: mode));
      products = await ProductRepo().fetchProductFinder(finder.text);
      emit(LoadedState(products: products, finder: finder, mode: mode));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    await ProductRepo().updateProduct(product);
  }
}
