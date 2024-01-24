import '../../../inventory_/product/model/product_model.dart';

class SaleProductModel {
  final ProductModel product;
  final double quantity;
  final double price;
  final String note;

  static const String _product = 'product';
  static const String _quantity = 'quantity';
  static const String _price = 'price';
  static const String _note = 'note';

  String get tProduct => _product;
  String get tQuantity => _quantity;
  String get tPrice => _price;
  String get tNote => _note;

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
