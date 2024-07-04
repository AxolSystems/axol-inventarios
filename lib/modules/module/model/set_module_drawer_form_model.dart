import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widget_link/model/widgetlink_model.dart';
import 'module_model.dart';

/// Modelo de datos con los valores mutables a través de
/// los estados de *SetModuleDrawer*.
///
/// - [ctrlName] : Controlador del campo de texto donde se edita el nombre del módulo.
/// - [ctrlIcon] : Controlador del campo de texto donde se edita el icono del módulo.
/// - [links] : Lista de widgetLinks que contiene el módulo.
/// - [initForm] : Un *map* que almacena variables inmutables del formulario en su
/// estado inicial. Se utiliza para hacer la verificación de si el form se mantiene
/// igual o cambió.
class SetModuleDrawerFormModel {
  TextEditingController ctrlName;
  TextEditingController ctrlIcon;
  List<WidgetLinkModel> links;
  final Map<EnumSetModuleForm, dynamic> initForm;

  SetModuleDrawerFormModel({
    required this.ctrlName,
    required this.ctrlIcon,
    required this.links,
    required this.initForm,
  });

  /// Estado inicial de este modelo de datos.
  SetModuleDrawerFormModel.empty(ModuleModel module)
      : ctrlName = TextEditingController(),
        ctrlIcon = TextEditingController(),
        links = [],
        initForm = {
          EnumSetModuleForm.ctrlName: module.name,
          EnumSetModuleForm.ctrlIcon: module.icon.codePoint.toString(),
          EnumSetModuleForm.links:
              List<WidgetLinkModel>.unmodifiable(module.widgetLinks),
        };

  /// Realiza la comparación entre el form actual y el inicial; devuelve
  /// *true* si son iguales.
  static bool compareForms(SetModuleDrawerFormModel form) {
    bool isEqual;
    int compareList = 0;
    dynamic links = [];

    links = form.initForm[EnumSetModuleForm.links];

    if (links.length == form.links.length) {
      if (links.isNotEmpty) {
        for (var link in links) {
          if (form.links.indexWhere(
                (x) => x.id == link.id,
              ) ==
              -1) {
            compareList++;
          }
        }
      }
    } else {
      compareList = 1;
    }

    isEqual =
        (form.ctrlIcon.text == form.initForm[EnumSetModuleForm.ctrlIcon]) &&
            (form.ctrlName.text == form.initForm[EnumSetModuleForm.ctrlName]) &&
            (compareList == 0);

    return isEqual;
  }
}

/// Enum para identificar las variables del formulario, útil para ubicar los parámetros
/// en un *map*.
enum EnumSetModuleForm { ctrlName, ctrlIcon, links }

/// Enum para identificar que tipo de acción se realizará en el drawer; por ejemplo, 
/// editar o agregar un módulo.
enum EnumSetModuleAction { add, edit }