import '../../../../models/textfield_form_model.dart';

class SaleNoteRowFormModel {
  TextfieldFormModel quantity;
  TextfieldFormModel productCode;
  TextfieldFormModel unitPrice;
  String description;
  String note;

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