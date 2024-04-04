import 'package:flutter/material.dart';

import '../../inventory_/product/model/product_model.dart';

class WbBottomSheetFormModel {
  String itemValue;
  TextEditingController controller;
  ProductModel product;
  String errorMessage;

  WbBottomSheetFormModel({
    required this.controller,
    required this.itemValue,
    required this.product,
    required this.errorMessage,
  });

  WbBottomSheetFormModel.empty()
      : controller = TextEditingController(),
        itemValue = '',
        product = ProductModel.empty(),
        errorMessage = '';
}
