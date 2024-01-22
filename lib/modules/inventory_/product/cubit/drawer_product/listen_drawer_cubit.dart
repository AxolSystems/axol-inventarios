import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListenProductCubit extends Cubit<ProductModel> {
  final ProductModel initialProduct;

  ListenProductCubit({required this.initialProduct}) : super(initialProduct);

  Future<void> change(ProductModel product, int keyChange, String value) async {
    //print(value);
    ProductModel changedProduct;
    Map<String, dynamic> properties = {};
    String productCode = product.code;
    String descriptionCode = product.description;
    int class_ = product.class_;
    final List<dynamic> propertiesKeys = List.from(product.properties!.keys);
    //print(propertiesKeys.length);
    for (int i = 0; i < propertiesKeys.length; i++) {
      if (i == keyChange) {
        if (i == 0) {
          productCode = value;
        } else if (i == 1) {
          descriptionCode = value;
        }
        properties[propertiesKeys[i]] = value;
      } else {
        properties[propertiesKeys[i]] = product.properties![propertiesKeys[i]];
      }
    }
    changedProduct = ProductModel(
        code: productCode,
        description: descriptionCode,
        properties: properties,
        class_: class_
        );
    //print(changedProduct.properties);
    emit(ProductModel.empty());
    emit(changedProduct);
  }

  ProductModel getProduct() {
    return state;
  }
}
