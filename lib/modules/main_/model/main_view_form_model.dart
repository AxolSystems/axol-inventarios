import 'package:flutter/material.dart';

import 'modul_model.dart';

class MainViewFormModel {
  Widget? body;
  int moduleSelect;
  List<ModuleModel> moduleList;
  bool moduleBarVisible;
  String title;

  MainViewFormModel(
      {required this.body,
      required this.moduleSelect,
      required this.moduleList,
      required this.moduleBarVisible,
      required this.title,
      });

  MainViewFormModel.empty()
      : body = null,
        moduleSelect = 0,
        moduleList = [],
        moduleBarVisible = true,
        title = '';
}
