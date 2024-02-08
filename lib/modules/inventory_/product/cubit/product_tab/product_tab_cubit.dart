import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../model/product_model.dart';
import '../../repository/product_repo.dart';
import 'product_tab_state.dart';

class ProductTabCubit extends Cubit<ProductTabState> {
  ProductTabCubit() : super(InitialProductTabState());

  Future<void> initLoad(TableViewFormModel form) async {
    try {
      List<ProductModel> products;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      emit(InitialProductTabState());
      emit(LoadingProductTabState());
      countReg = await ProductRepo().countRecords();
      products = await ProductRepo().fetchProductFinder(form.finder.text,
          rangeMax: limit - 1, rangeMin: 0);
      form.currentPage = 1;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      emit(LoadedProductTabState(products: products));
    } catch (e) {
      emit(ErrorProductTabState(error: e.toString()));
    }
  }

  Future<void> load(TableViewFormModel form) async {
    try {
      final int countReg;
      final int rangeMin;
      final int rangeMax;
      final int limit = TableViewFormModel.rows50;
      List<ProductModel> products;
      emit(InitialProductTabState());
      emit(LoadingProductTabState());
      countReg = await ProductRepo().countRecords();
      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;
      products = await ProductRepo().fetchProductFinder(
        form.finder.text,
        rangeMax: rangeMax,
        rangeMin: rangeMin,
      );
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      emit(LoadedProductTabState(products: products));
    } catch (e) {
      emit(ErrorProductTabState(error: e.toString()));
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    await ProductRepo().updateProduct(product);
  }
}
