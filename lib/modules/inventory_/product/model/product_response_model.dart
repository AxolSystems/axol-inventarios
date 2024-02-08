import 'product_model.dart';

class ProductResponseModel {
  final List<ProductModel> productList;
  final int count;

  ProductResponseModel({required this.productList, required this.count});
}
