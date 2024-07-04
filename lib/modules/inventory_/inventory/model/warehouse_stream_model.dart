import '../../../../models/validation_form_model.dart';

class WarehouseStreamModel {
  WHTextfieldModel textfieldId;
  WHTextfieldModel textfieldName;
  WHDropdownModel dropdownManager;

  WarehouseStreamModel({
    required this.textfieldId,
    required this.dropdownManager,
    required this.textfieldName,
  });

  static WarehouseStreamModel initial() => WarehouseStreamModel(
    dropdownManager: WHDropdownModel.initial(),
    textfieldId: WHTextfieldModel.initial(),
    textfieldName: WHTextfieldModel.initial(),
  );
}

class WHTextfieldModel {
  String text;
  int position;
  ValidationFormModel validation;

  WHTextfieldModel({
    required this.text,
    required this.position,
    required this.validation,
  });

  static WHTextfieldModel initial() => WHTextfieldModel(
        text: '',
        position: 0,
        validation: ValidationFormModel(isValid: true, errorMessage: ''),
      );
}

class WHDropdownModel {
  String value;
  ValidationFormModel validation;

  WHDropdownModel({
    required this.value,
    required this.validation,
  });

  static WHDropdownModel initial() => WHDropdownModel(
    value: '',
    validation: ValidationFormModel(isValid: true, errorMessage: ''),
  );
}
