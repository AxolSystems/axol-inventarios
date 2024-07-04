import 'package:flutter/material.dart';

import '../../widget_link/model/widgetlink_model.dart';

/// Modelo de datos que representa a una módulo.
///
/// TODO: verificar si es necesaria la propiedad onPressed.
class ModuleModel {
  final String id;
  final String name;
  final IconData icon;
  final List<WidgetLinkModel> widgetLinks;
  final Map<String, dynamic> permissions;
  final Function()? onPressed;

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

  /// Crea un *ModuleModel* a partir de otro, modificando solamente el id.
  ModuleModel.setId({required ModuleModel module, required String newId})
      : id = newId,
        name = module.name,
        icon = module.icon,
        widgetLinks = module.widgetLinks,
        permissions = module.permissions,
        onPressed = module.onPressed;
}
