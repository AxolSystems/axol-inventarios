import '../../../../models/textfield_form_model.dart';

class ProductEditFormModel {
  TextfieldFormModel tfDescription;
  TextfieldFormModel tfPacking;
  TextfieldFormModel tfType;
  TextfieldFormModel tfCapacity;
  TextfieldFormModel tfMasure;
  TextfieldFormModel tfGauge;
  TextfieldFormModel tfPices;
  TextfieldFormModel tfWeight;
  TextfieldFormModel tfPrice;
  TextfieldFormModel tfUnitSale;
  int class_;
  int focusIndex;

  ProductEditFormModel({
    required this.tfDescription,
    required this.tfPacking,
    required this.tfCapacity,
    required this.tfWeight,
    required this.tfGauge,
    required this.tfMasure,
    required this.tfPices,
    required this.tfType,
    required this.focusIndex,
    required this.tfPrice,
    required this.tfUnitSale,
    required this.class_,
  });

  ProductEditFormModel.empty()
      : tfDescription = TextfieldFormModel.empty(),
        tfPacking = TextfieldFormModel.empty(),
        tfCapacity = TextfieldFormModel.empty(),
        tfGauge = TextfieldFormModel.empty(),
        tfMasure = TextfieldFormModel.empty(),
        tfPices = TextfieldFormModel.empty(),
        tfType = TextfieldFormModel.empty(),
        tfWeight = TextfieldFormModel.empty(),
        tfPrice = TextfieldFormModel.empty(),
        tfUnitSale = TextfieldFormModel.empty(),
        class_ = -1,
        focusIndex = -1;
}
