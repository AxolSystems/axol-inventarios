import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:flutter/material.dart';

import '../../../object/model/reference_object_model.dart';

/// Modelo de datos con propiedades mutables a traves
/// de los estados del drawer de detalles del objeto.
class ObjectDetailsFormModel {
  Map<String, RowDetailsController> controllers;
  bool edit;
  ObjectModel object;

  ObjectDetailsFormModel({
    required this.controllers,
    required this.edit,
    required this.object,
  });

  /// Estado inicial del form.
  ObjectDetailsFormModel.empty()
      : controllers = {},
        edit = false,
        object = ObjectModel.empty();
}

abstract class RowDetailsController {}

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
  DateTime controller;
  RDDateController({required this.controller});
  RDDateController.empty() : controller = DateTime(0);
}

class RDReferenceObject extends RowDetailsController {
  ReferenceObjectModel refObject;
  RDReferenceObject({required this.refObject});
  RDReferenceObject.empty() : refObject = ReferenceObjectModel.empty();
}
