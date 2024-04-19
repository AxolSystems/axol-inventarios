import 'package:flutter/cupertino.dart';

import '../../inventory_/product/model/product_model.dart';

class SrpAddBottomsheetFormModel {
  TextEditingController qtyCtrl;
  TextEditingController unitPriceCtrl;
  TextEditingController customerCtrl;
  ProductModel product;
  String? errorMessageQty;
  String? errorMessagePrice;
  double stock;
  bool? initEdit;

  SrpAddBottomsheetFormModel({
    required this.qtyCtrl,
    required this.product,
    required this.errorMessageQty,
    required this.stock,
    required this.unitPriceCtrl,
    required this.customerCtrl,
    required this.errorMessagePrice,
    this.initEdit,
  });

  SrpAddBottomsheetFormModel.empty()
      : qtyCtrl = TextEditingController(),
        unitPriceCtrl = TextEditingController(),
        customerCtrl = TextEditingController(),
        product = ProductModel.empty(),
        errorMessageQty = null,
        errorMessagePrice = null,
        stock = 0,
        initEdit = null;
}
