import 'package:flutter/material.dart';

import '../../axol_widget/axol_widget.dart';
import 'entry_menu_model.dart';
import 'main_view_form_model.dart';

class ModuleModel {
  String id;
  String text;
  IconData icon;
  int position;
  List<EntryMenuModel> menu;
  Map permissions;
  AxolWidget widget;
  Function()? onPressed;

  ModuleModel({
    required this.text,
    required this.id,
    required this.icon,
    required this.position,
    required this.menu,
    required this.permissions,
    required this.widget,
    this.onPressed,
  });

  ModuleModel.empty()
      : id = '',
        text = '',
        icon = Icons.square,
        position = -1,
        menu = [],
        permissions = {},
        widget = const TextAW(text: ''),
        onPressed = null;
}
