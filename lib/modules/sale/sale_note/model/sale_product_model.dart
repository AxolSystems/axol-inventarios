import '../../../inventory_/product/model/product_model.dart';
import 'salenote_row_form_model.dart';

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

  SaleProductModel.setProduct(
      {required this.product, required SaleProductModel productSale})
      : quantity = productSale.quantity,
        price = productSale.price,
        note = productSale.note;

  static List<SaleProductModel> rowToSale(List<SaleNoteRowFormModel> rowList) {
    List<SaleProductModel> saleProductList = [];
    SaleProductModel saleProduct;

    for (var row in rowList) {
      saleProduct = SaleProductModel(
        product: row.product,
        quantity: double.tryParse(row.quantity.value) ?? 0,
        price: double.tryParse(row.unitPrice.value) ?? 0,
        note: row.note,
      );
      saleProductList.add(saleProduct);
    }

    return saleProductList;
  }
}
