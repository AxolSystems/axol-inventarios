import 'package:flutter/material.dart';

import 'modul_model.dart';

class MainViewFormModel {
  Widget? body;
  int moduleSelect;
  int menuSelect;
  List<ModuleModel> moduleList;
  bool moduleBarVisible;
  bool menuVisible;
  String title;

  MainViewFormModel(
      {required this.body,
      required this.moduleSelect,
      required this.moduleList,
      required this.moduleBarVisible,
      required this.title,
      required this.menuVisible,
      required this.menuSelect,
      });

  MainViewFormModel.empty()
      : body = null,
        moduleSelect = 0,
        menuSelect = -1,
        moduleList = [],
        moduleBarVisible = true,
        menuVisible = true,
        title = '';
}
