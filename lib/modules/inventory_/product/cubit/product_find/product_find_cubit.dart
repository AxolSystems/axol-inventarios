import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_find.dart';
import '../../../../../utilities/widgets/drawer_find.dart';
import '../../model/product_model.dart';
import '../../repository/product_repo.dart';

class ProductFindCubit extends Cubit<DrawerFindState> {
  ProductFindCubit() : super(InitialDrawerFindState());

  Future<void> load(String find) async {
    List<ProductModel> productsDB;
    List<DataFind> dataList = [];
    DataFind data;
    try {
      emit(InitialDrawerFindState());
      emit(LoadingDrawerFindState());
      productsDB = await ProductRepo().fetchProductFinder(find);
      for (var product in productsDB) {
        data = DataFind(id: product.code, description: product.description, data: product);
        dataList.add(data);
      }
      emit(LoadedDrawerFindState(dataList: dataList));
    } catch (e) {
      emit(InitialDrawerFindState());
      emit(ErrorDrawerFindState(error: e.toString()));
    }
  }
}