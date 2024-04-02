import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_find.dart';
import '../../../../../models/data_response_model.dart';
import '../../../../../utilities/widgets/drawer_find.dart';
import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../../inventory/model/warehouse_model.dart';
import '../../../inventory/repository/inventory_repo.dart';
import '../../model/product_find_form_model.dart';
import '../../model/product_response_model.dart';
import '../../repository/product_repo.dart';

class ProductFindCubit extends Cubit<DrawerFindState> {
  ProductFindCubit() : super(InitialDrawerFindState());

  Future<void> load(ProductFindFormModel form, WarehouseModel warehouse, {int? currentPage}) async {
    ProductResponseModel productsResponse;
    DataResponseModel dataResponse;
    List<DataFindValues> valuesList = [];
    DataFindValues data;
    final int countReg;
    final int rangeMin;
    final int rangeMax;
    final int limit = TableViewFormModel.rows50;
    final String find = form.textfield.controller.text;
    try {
      emit(InitialDrawerFindState());
      emit(LoadingDrawerFindState());
      print('flag1');
      if (currentPage != null) {
        form.currentPage = 1;
      }
      
      rangeMin = (form.currentPage * limit) - limit;
      rangeMax = (form.currentPage * limit) - 1;
      if (form.productListFind == ProductListFind.inventory) {
        print('flag2');
        dataResponse = await InventoryRepo().fetchInventoryList(
          find,
          warehouse.name,
          rangeMin: rangeMin,
          rangeMax: rangeMax,
        );
        print('flag3');
        for (var inventory in dataResponse.dataList) {
          data = DataFindValues(values: [
            inventory.product.code,
            inventory.product.description,
            inventory.stock.toString()
          ], data: inventory);
          valuesList.add(data);
        }
        countReg = dataResponse.count;
      } else if (form.productListFind == ProductListFind.product) {
        productsResponse = await ProductRepo().fetchProductFinder(
          find,
          rangeMax: rangeMax,
          rangeMin: rangeMin,
        );
        for (var product in productsResponse.productList) {
          data = DataFindValues(
            values: [
              product.code,
              product.description,
            ],
            data: product,
          );
          valuesList.add(data);
        }
        countReg = productsResponse.count;
      } else {
        countReg = 0;
      }

      form.limitPage = (countReg / limit).ceil();
      form.totalReg = countReg;
      
      emit(LoadedDrawerFindState(valuesList: valuesList, dataList: const []));
    } catch (e) {
      emit(InitialDrawerFindState());
      emit(ErrorDrawerFindState(error: e.toString()));
    }
  }
}

class ProductFindForm extends Cubit<ProductFindFormModel> {
  ProductFindForm() : super(ProductFindFormModel.empty());
}
