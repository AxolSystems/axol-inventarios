import '../modules/inventory_/product/model/product_model.dart';

class InventoryRowModel {
  final ProductModel product;
  final double stock;
  final String warehouseName;

  static String get tProduct => 'product';
  static String get tStock => 'stock';
  static String get tWarehouseName => 'warehouse_name';

  const InventoryRowModel({
    required this.product,
    required this.stock,
    required this.warehouseName,
  });

  InventoryRowModel.empty() : 
  product = ProductModel.empty(),
  stock = 0,
  warehouseName = '';

  InventoryRowModel.setStock(
      {required InventoryRowModel inventoryRow, required this.stock})
      : product = inventoryRow.product,
        warehouseName = inventoryRow.warehouseName;

  static Map<String, dynamic> rowToMapWaybill(
      List<InventoryRowModel> inventoryRowList) {
    Map<String, dynamic> map = {};
    for (int i = 0; i < inventoryRowList.length; i++) {
      map[i.toString()] =
          '${inventoryRowList[i].product.code}~${inventoryRowList[i].stock}~${inventoryRowList[i].warehouseName}';
    }
    return map;
  }
}
