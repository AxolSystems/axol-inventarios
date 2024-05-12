import 'package:flutter/material.dart';

import 'entry_menu_model.dart';

class ModuleModel {
  String id;
  String text;
  IconData icon;
  int position;
  List<EntryMenuModel> menu;
  Map permissions;

  ModuleModel({
    required this.text,
    required this.id,
    required this.icon,
    required this.position,
    required this.menu,
    required this.permissions,
  });
}
