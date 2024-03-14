import '../../product/model/product_model.dart';

class ReportInventoryRowModel {
  final ProductModel product;
  final double quantity;

  const ReportInventoryRowModel({
    required this.product,
    required this.quantity,
  });
}
