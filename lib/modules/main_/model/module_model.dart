import 'package:flutter/material.dart';

import '../../axol_widget/axol_widget.dart';
import '../../widget_link/model/widgetlink_model.dart';

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

  ModuleModel.empty()
      : id = '',
        name = '',
        icon = Icons.square,
        widgetLinks = [],
        permissions = {},
        onPressed = null;
}
