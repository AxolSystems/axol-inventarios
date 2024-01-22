import '../../../inventory_/product/model/product_model.dart';

class SaleProductModel {
  final ProductModel product;
  final double quantity;
  final double price;
  final String note;

  static const String propProduct = 'product';
  static const String propQuantity = 'quantity';
  static const String propPrice = 'price';
  static const String propNote = 'note';

  SaleProductModel({
    required this.product,
    required this.quantity,
    required this.price,
    required this.note,
  });

  static SaleProductModel empty() => SaleProductModel(
    note: '',
    price: 0,
    product: ProductModel.empty(),
    quantity: 0,
  );
}
