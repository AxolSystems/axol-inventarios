import 'package:flutter/material.dart';

import '../../inventory_/product/model/product_model.dart';

class WbBottomSheetAddFormModel {
  String itemValue;
  TextEditingController controller;
  ProductModel product;
  String? errorMessage;
  double stock;

  WbBottomSheetAddFormModel({
    required this.controller,
    required this.itemValue,
    required this.product,
    required this.errorMessage,
    required this.stock
  });

  WbBottomSheetAddFormModel.empty()
      : controller = TextEditingController(),
        itemValue = '',
        product = ProductModel.empty(),
        errorMessage = null,
        stock = 0;
}
