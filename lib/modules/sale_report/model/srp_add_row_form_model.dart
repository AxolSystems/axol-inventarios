import 'package:axol_inventarios/models/inventory_row_model.dart';
import 'package:flutter/cupertino.dart';

import '../../inventory_/product/model/product_model.dart';
import 'salereport_row_model.dart';

class SrpAddRowFormModel {
  TextEditingController qtyCtrl;
  TextEditingController unitPriceCtrl;
  TextEditingController customerCtrl;
  ProductModel product;
  String? errorMessageQty;
  String? errorMessagePrice;
  double stock;

  SrpAddRowFormModel({
    required this.qtyCtrl,
    required this.product,
    required this.errorMessageQty,
    required this.stock,
    required this.unitPriceCtrl,
    required this.customerCtrl,
    required this.errorMessagePrice,
  });

  SrpAddRowFormModel.empty()
      : qtyCtrl = TextEditingController(),
        unitPriceCtrl = TextEditingController(),
        customerCtrl = TextEditingController(),
        product = ProductModel.empty(),
        errorMessageQty = null,
        errorMessagePrice = null,
        stock = 0;

  SrpAddRowFormModel.set(
      {required SaleReportRowModel reportRow,
      required InventoryRowModel inventoryRow})
      : customerCtrl = TextEditingController(text: reportRow.customerName),
        errorMessagePrice = null,
        errorMessageQty = null,
        product = reportRow.product,
        qtyCtrl = TextEditingController(text: reportRow.quantity.toString()),
        stock = inventoryRow.stock,
        unitPriceCtrl =
            TextEditingController(text: reportRow.unitPrice.toString());
}
