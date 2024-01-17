import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:flutter/material.dart';

class TextfieldFormModel {
  TextEditingController controller;
  String key;
  List<String> tags;
  String value;
  int position;
  ValidationFormModel validation;
  bool isLoading;
  bool? isFocus;

  TextfieldFormModel({
    required this.position,
    required this.validation,
    required this.value,
    required this.key,
    required this.controller,
    required this.isLoading,
    required this.tags,
    this.isFocus,
  });

  TextfieldFormModel.empty()
      : position = 0,
        validation = ValidationFormModel.trueValid(),
        value = '',
        key = '',
        controller = TextEditingController(),
        isLoading = false,
        tags = [];

  TextfieldFormModel.initKey({
    required this.key,
    required this.tags,
  })  : position = 0,
        validation = ValidationFormModel.trueValid(),
        value = '',
        controller = TextEditingController(),
        isLoading = false;

  static const String pValue = 'value';
  static const String pPosition = 'position';
  static const String pValidation = 'validation';
}
