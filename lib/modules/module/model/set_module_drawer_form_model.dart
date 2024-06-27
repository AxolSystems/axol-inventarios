import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widget_link/model/widgetlink_model.dart';

/// Modelo de datos con los valores mutables a través de 
/// los estados de *SetModuleDrawer*.
/// 
/// - [ctrlName] : Controlador del campo de texto donde se edita el nombre del módulo.
/// - [ctrlIcon] : Controlador del campo de texto donde se edita el icono del módulo.
/// - [links] : Lista de widgetLinks que contiene el módulo.
class SetModuleDrawerFormModel {
  TextEditingController ctrlName;
  TextEditingController ctrlIcon;
  List<WidgetLinkModel> links;

  SetModuleDrawerFormModel({
    required this.ctrlName,
    required this.ctrlIcon,
    required this.links,
  });

  /// Estado inicial de este modelo de datos.
  SetModuleDrawerFormModel.empty()
      : ctrlName = TextEditingController(),
        ctrlIcon = TextEditingController(),
        links = [];
}
