import 'package:axol_inventarios/models/textfield_model.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/repository/routecustomer_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/routcustomer_model.dart';
import 'routcustomer_state.dart';

class RoutcustomerCubit extends Cubit<RoutcustomerState> {
  RoutcustomerCubit() : super(InitialState());

  Future<void> load(
    TextfieldModel finder,
  ) async {
    try {
      List<RoutcustomerModel> customersDB;
      emit(InitialState());
      emit(LoadingState(textfieldFinder: finder));
      customersDB = await RoutcustomerRepo().fetchRcList(finder.text);
      emit(LoadedState(rcList: customersDB, textfieldFinder: finder));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  /*Future<void> reloadList(TextfieldModel finder, int mode) async {
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
  }*/
}
