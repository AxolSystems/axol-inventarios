import '../../../../models/textfield_form_model.dart';

class SaleNoteRowFormModel {
  TextfieldFormModel quantity;
  TextfieldFormModel productCode;
  TextfieldFormModel unitPrice;
  String description;
  String note;

  final String _keyQuantity = 'quantity';
  final String _keyProduct = 'product';
  final String _keyPrice = 'price';

  String get keyQuantity => _keyQuantity;
  String get keyProduct => _keyProduct;
  String get keyPrice => _keyPrice;
  String get emEmptyData => 'Ingrese un valor';
  String get emNotStock => 'Stock insuficiente';
  String get emInvalidData => 'Dato invalido';

  SaleNoteRowFormModel({
    required this.quantity,
    required this.productCode,
    required this.unitPrice,
    required this.description,
    required this.note,
  });

  SaleNoteRowFormModel.empty() :
        quantity =  TextfieldFormModel.empty(),
        productCode = TextfieldFormModel.empty(),
        unitPrice = TextfieldFormModel.empty(),
        description = '',
        note = '';
}