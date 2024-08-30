import 'package:flutter/material.dart';

import '../../../array/model/array_model.dart';
import '../../../entity/model/property_model.dart';
import '../../../object/model/atomic_object_model.dart';
import '../../../object/model/reference_object_model.dart';

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
  TextEditingController ctrlNum;
  NumberFieldModel({required this.ctrlNum, required super.property});
}

class BooleanFieldModel extends FormFieldModel {
  bool value;
  BooleanFieldModel({required this.value, required super.property});
}

class DateFieldModel extends FormFieldModel {
  DateTime dateTime;
  DateFieldModel({required this.dateTime, required super.property});
}

class ReferenceObjectFieldModel extends FormFieldModel {
  ReferenceObjectModel refObj;
  ReferenceObjectFieldModel({required this.refObj, required super.property});
}

class AtmObjFieldModel extends FormFieldModel {
  AtomicObjectModel atomicObject;
  AtmObjFieldModel({required this.atomicObject, required super.property});
}

class ArrayFieldModel extends FormFieldModel {
  ArrayModel array;
  ArrayFieldModel({required this.array, required super.property});
}
