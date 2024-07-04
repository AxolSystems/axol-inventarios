import '../../product/model/product_model.dart';

class ReportInventoryRowModel {
  final ProductModel product;
  final double quantity;

  const ReportInventoryRowModel({
    required this.product,
    required this.quantity,
  });

  ReportInventoryRowModel.addProduct({
    required ReportInventoryRowModel reportInventoryRow,
    required double quantity,
  })  : product = reportInventoryRow.product,
        quantity = reportInventoryRow.quantity + quantity;
}
