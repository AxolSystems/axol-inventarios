import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_edit_state.dart';

class ProductEditCubit extends Cubit<ProductEditState> {
  ProductEditCubit() : super(InitialProductEditState());
  
  Future<void> load() async {
    try {
      emit(InitialProductEditState());
      emit(LoadingProductEditState());
      emit(LoadedProductEditState());
    } catch (e) {
      emit(ErrorProductEditState(error: e.toString()));
    }
  }
}