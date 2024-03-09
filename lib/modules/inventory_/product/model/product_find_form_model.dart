import '../../../../models/textfield_form_model.dart';

enum ProductListFind { product, inventory }

class ProductFindFormModel {
  TextfieldFormModel textfield;
  ProductListFind productListFind;
  int currentPage;
  int limitPage;
  int totalReg;

  ProductFindFormModel({
    required this.textfield,
    required this.productListFind,
    required this.currentPage,
    required this.limitPage,
    required this.totalReg,
  });

  ProductFindFormModel.empty()
      : textfield = TextfieldFormModel.empty(),
        productListFind = ProductListFind.inventory,
        currentPage = 0,
        limitPage = 0,
        totalReg = 0;
}
