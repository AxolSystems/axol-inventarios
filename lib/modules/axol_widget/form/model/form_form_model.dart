import 'package:flutter/material.dart';

class FormFormModel {
  List<FormFieldModel> fields;

  FormFormModel({required this.fields});

  FormFormModel.empty() : fields = [];
}

abstract class FormFieldModel {}

class TextFieldModel extends FormFieldModel {
  TextEditingController ctrlText;
  TextFieldModel({required this.ctrlText});
}