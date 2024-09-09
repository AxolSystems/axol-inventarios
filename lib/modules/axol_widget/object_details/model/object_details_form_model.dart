import 'package:axol_inventarios/modules/object/model/atomic_object_model.dart';
import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:flutter/material.dart';

import '../../../array/model/array_model.dart';
import '../../../object/model/reference_object_model.dart';

/// Modelo de datos con propiedades mutables a traves
/// de los estados del drawer de detalles del objeto.
class ObjectDetailsFormModel {
  Map<String, RowDetailsController> controllers;
  bool edit;
  bool isEdited;
  ObjectModel object;

  ObjectDetailsFormModel({
    required this.controllers,
    required this.edit,
    required this.object,
    required this.isEdited,
  });

  /// Estado inicial del form.
  ObjectDetailsFormModel.empty()
      : controllers = {},
        edit = false,
        object = ObjectModel.empty(),
        isEdited = false;
}

abstract class RowDetailsController {
  String? error;
  RowDetailsController({this.error});
}

class RDTextEditingController extends RowDetailsController {
  TextEditingController controller;
  RDTextEditingController({required this.controller});
  RDTextEditingController.empty() : controller = TextEditingController();
}

class RDBoolController extends RowDetailsController {
  bool controller;
  RDBoolController({required this.controller});
  RDBoolController.init() : controller = false;
}

class RDDateController extends RowDetailsController {
  DateTime? controller;
  RDDateController({required this.controller});
  RDDateController.empty() : controller = DateTime(0);
}

class RDReferenceObject extends RowDetailsController {
  ReferenceObjectModel refObject;
  String oldIdRefObject;
  RDReferenceObject({required this.refObject, required this.oldIdRefObject});
  RDReferenceObject.empty()
      : refObject = ReferenceObjectModel.empty(),
        oldIdRefObject = '';
}

class RDAtomicObject extends RowDetailsController {
  AtomicObjectModel atmObject;
  RDAtomicObject({required this.atmObject});
  RDAtomicObject.empty(String id) : atmObject = AtomicObjectModel.idInit(id);
}

class RDArray extends RowDetailsController {
  ArrayModel array;
  RDArray({required this.array});
  RDArray.empty() : array = ArrayModel.empty();
}

class RDFormula extends RowDetailsController {
  String formula;
  String value;
  RDFormula({required this.formula, required this.value, required super.error});
  RDFormula.empty() : formula = '', value = '';
}
