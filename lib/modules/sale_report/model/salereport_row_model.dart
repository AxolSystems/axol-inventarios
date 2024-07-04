import '../../inventory_/product/model/product_model.dart';

class SaleReportRowModel {
  final ProductModel product;
  final double quantity;
  final double unitPrice;
  final String customerName;

  SaleReportRowModel({
    required this.customerName,
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  SaleReportRowModel.empty() : 
  customerName = '',
  product = ProductModel.empty(),
  quantity = 0,
  unitPrice = 0;
}