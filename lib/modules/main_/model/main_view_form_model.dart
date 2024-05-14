import 'package:flutter/material.dart';

import 'modul_model.dart';

class MainViewFormModel {
  Widget? body;
  int moduleSelect;
  List<ModuleModel> moduleList;

  MainViewFormModel(
      {required this.body,
      required this.moduleSelect,
      required this.moduleList});

  MainViewFormModel.empty()
      : body = null,
        moduleSelect = 0,
        moduleList = [];
}
