import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../inventory_/product/model/product_model.dart';
import '../../../../inventory_/product/repository/product_repo.dart';
import '../../model/sale_product_model.dart';
import 'salenote_details_state.dart';

class SaleNoteDetailsCubit extends Cubit<SaleNoteDetailsState> {
  SaleNoteDetailsCubit() : super(InitialSaleNoteDetailsState());

  Future<void> load(List<SaleProductModel> productList) async {
    ProductModel? productDB;
    ProductModel product;
    List<SaleProductModel> upProductList = [];
    SaleProductModel upProductSale;
    try {
      emit(InitialSaleNoteDetailsState());
      emit(LoadingSaleNoteDetailsState());
      for (SaleProductModel productSale in productList) {
        productDB =
            await ProductRepo().fetchProduct(productSale.product.code);
        product = productDB ?? ProductModel.empty();
        upProductSale = SaleProductModel(
            product: product,
            quantity: productSale.quantity,
            price: productSale.price,
            note: productSale.note);
        upProductList.add(upProductSale);
      }

      emit(LoadedSaleNoteDetailsState(productList: upProductList));
    } catch (e) {
      emit(InitialSaleNoteDetailsState());
      emit(ErrorSaleNoteDetailsState(error: e.toString()));
    }
  }
}
