import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:flutter/material.dart';

/// Modelo de datos con propiedades mutables a traves 
/// de los estados del drawer de detalles del objeto.
class RowDetailsFormModel {
  Map<String, TextEditingController> controllers;
  bool edit;
  ObjectModel object;

  RowDetailsFormModel({
    required this.controllers,
    required this.edit,
    required this.object,
  });

  /// Estado inicial del form.
  RowDetailsFormModel.empty()
      : controllers = {},
        edit = false,
        object = ObjectModel.empty();
}
