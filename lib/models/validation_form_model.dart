class ValidationFormModel {
  final bool isValid;
  final String errorMessage;

  ValidationFormModel({required this.isValid, required this.errorMessage});

  ValidationFormModel.trueValid()
      : isValid = true,
        errorMessage = '';

  ValidationFormModel.falseValid(this.errorMessage)
      : isValid = false;
}
