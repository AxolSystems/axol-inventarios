import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../inventory_/product/model/product_model.dart';
import '../../../../inventory_/product/repository/product_repo.dart';
import '../../model/sale_product_model.dart';
import 'salenote_details_state.dart';

class SaleNoteDetailsCubit extends Cubit<SaleNoteDetailsState> {
  SaleNoteDetailsCubit() : super(InitialSaleNoteDetailsState());

  Future<void> load(List<SaleProductModel> productList) async {
    final ProductModel? productDB;
    final sale product;
    List<SaleProductModel> upProductList = [];
    try {
      emit(InitialSaleNoteDetailsState());
      emit(LoadingSaleNoteDetailsState());
      for (SaleProductModel productSale in productList) {
        
      }
      productDB = await ProductRepo().fetchProductByCode(productCode);
      product = productDB ?? ProductModel.empty();
      emit(LoadedSaleNoteDetailsState(product: product));
    } catch (e) {
      emit(InitialSaleNoteDetailsState());
      emit(ErrorSaleNoteDetailsState(error: e.toString()));
    }
  }
}
