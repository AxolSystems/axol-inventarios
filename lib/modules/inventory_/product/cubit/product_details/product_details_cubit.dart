import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(InitialProductDetailsState());
  
  Future<void> load() async {
    try {
      
      emit(InitialProductDetailsState());
      emit(LoadingProductDetailsState());

      emit(LoadedProductDetailsState());
    } catch (e) {
      emit(ErrorProductDetailsState(error: e.toString()));
    }
  }
}