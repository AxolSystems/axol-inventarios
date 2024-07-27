import 'package:flutter/material.dart';

import '../../../entity/model/property_model.dart';

class FormFormModel {
  List<FormFieldModel> fields;

  FormFormModel({required this.fields});

  FormFormModel.empty() : fields = [];
}

abstract class FormFieldModel {
  PropertyModel property;
  FormFieldModel({required this.property});
}

class TextFieldModel extends FormFieldModel {
  TextEditingController ctrlText;
  TextFieldModel({required this.ctrlText, required super.property});
}

class NumberFieldModel extends FormFieldModel {
  TextEditingController ctrlText;
  NumberFieldModel({required this.ctrlText, required super.property});
}
