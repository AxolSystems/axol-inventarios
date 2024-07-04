import '../../../../models/textfield_form_model.dart';

enum ProductListFind { product, inventory }

class ProductFindFormModel {
  TextfieldFormModel tfFind;
  ProductListFind productListFind;
  int currentPage;
  int limitPage;
  int totalReg;

  ProductFindFormModel({
    required this.tfFind,
    required this.productListFind,
    required this.currentPage,
    required this.limitPage,
    required this.totalReg,
  });

  ProductFindFormModel.empty()
      : tfFind = TextfieldFormModel.empty(),
        productListFind = ProductListFind.inventory,
        currentPage = 0,
        limitPage = 0,
        totalReg = 0;
}
