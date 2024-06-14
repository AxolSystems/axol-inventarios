import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../../../user/model/user_model.dart';
import '../../../../user/repository/user_repo.dart';
import '../../model/product_model.dart';
import '../../model/product_response_model.dart';
import '../../repository/product_repo.dart';
import 'product_tab_state.dart';

class ProductTabCubit extends Cubit<ProductTabState> {
  ProductTabCubit() : super(InitialProductTabState());

  Future<void> initLoad(TableViewFormModel form) async {
    try {
      ProductResponseModel productResponse;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      final UserModel user;
      emit(InitialProductTabState());
      user = await LocalUser().getLocalUser();
      form.user = user;
      emit(LoadingProductTabState());
      //countReg = await ProductRepo().countRecords();
      productResponse = await ProductRepo().fetchProductFinder(form.finder.text,
          rangeMax: limit - 1, rangeMin: 0);
      countReg = productResponse.count;
      form.currentPage = 1;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      emit(LoadedProductTabState(products: productResponse.productList));
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
      ProductResponseModel productResponse;
      emit(InitialProductTabState());
      emit(LoadingProductTabState());
      //countReg = await ProductRepo().countRecords();
      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;
      productResponse = await ProductRepo().fetchProductFinder(
        form.finder.text,
        rangeMax: rangeMax,
        rangeMin: rangeMin,
      );
      countReg = productResponse.count;
      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      emit(LoadedProductTabState(products: productResponse.productList));
    } catch (e) {
      emit(ErrorProductTabState(error: e.toString()));
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    await ProductRepo().update(product);
  }
}
