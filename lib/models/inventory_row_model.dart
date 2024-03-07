import '../modules/inventory_/product/model/product_model.dart';

class InventoryRowModel {
  final ProductModel product;
  final double stock;
  final String warehouseName;

  const InventoryRowModel({
    required this.product,
    required this.stock,
    required this.warehouseName,
  });
}
