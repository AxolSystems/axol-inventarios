import 'package:flutter/material.dart';

import '../../inventory_/product/model/product_model.dart';

class WbBottomSheetAddFormModel {
  //String itemValue;
  TextEditingController qtyCtrl;
  ProductModel product;
  String? errorMessage;
  double stock;

  WbBottomSheetAddFormModel(
      {required this.qtyCtrl,
      //required this.itemValue,
      required this.product,
      required this.errorMessage,
      required this.stock});

  WbBottomSheetAddFormModel.empty()
      : qtyCtrl = TextEditingController(),
        //itemValue = '',
        product = ProductModel.empty(),
        errorMessage = null,
        stock = 0;

  WbBottomSheetAddFormModel.set(WbBottomSheetAddFormModel form)
      : qtyCtrl = form.qtyCtrl,
        product = form.product,
        errorMessage = form.errorMessage,
        stock = form.stock;
}
