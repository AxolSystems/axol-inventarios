import 'package:flutter/material.dart';

import '../../widget_link/model/widgetlink_model.dart';

/// Modelo de datos que representa a una módulo.
/// 
/// TODO: verificar si es necesaria la propiedad onPressed.
class ModuleModel {
  String id;
  String name;
  IconData icon;
  List<WidgetLinkModel> widgetLinks;
  Map permissions;
  Function()? onPressed;

  ModuleModel({
    required this.name,
    required this.id,
    required this.icon,
    required this.widgetLinks,
    required this.permissions,
    this.onPressed,
  });

  /// Devuelve el estado inicial del modelo de datos.
  ModuleModel.empty()
      : id = '',
        name = '',
        icon = Icons.square,
        widgetLinks = [],
        permissions = {},
        onPressed = null;
}
