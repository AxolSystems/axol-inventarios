import 'product_model.dart';

class ProductResponseModel {
  List<ProductModel> productList;
  int count;

  ProductResponseModel({required this.productList, required this.count});

  ProductResponseModel.empty()
      : productList = [],
        count = 0;
}
