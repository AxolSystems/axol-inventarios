import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../model/product_model.dart';
import '../../repository/product_repo.dart';
import 'product_tab_state.dart';

class ProductTabCubit extends Cubit<ProductTabState> {
  ProductTabCubit() : super(InitialProductTabState());

  Future<void> initLoad() async {
    try {
      List<ProductModel> products;
      emit(InitialProductTabState());
      emit(LoadingProductTabState());
      products = await ProductRepo().fetchAllProducts();
      emit(LoadedProductTabState(products: products));
    } catch (e) {
      emit(ErrorProductTabState(error: e.toString()));
    }
  }

  Future<void> load(TableViewFormModel form) async {
    try {
      List<ProductModel> products;
      emit(InitialProductTabState());
      emit(LoadingProductTabState());
      products = await ProductRepo().fetchProductFinder(form.finder.text);
      emit(LoadedProductTabState(products: products));
    } catch (e) {
      emit(ErrorProductTabState(error: e.toString()));
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    await ProductRepo().updateProduct(product);
  }
}
