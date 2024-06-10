import 'package:axol_inventarios/modules/axol_widget/axol_widget.dart';

import '../../user/model/user_mdoel.dart';
import 'modul_model.dart';

class MainViewFormModel {
  AxolWidget? body;
  int moduleSelect;
  int menuSelect;
  List<ModuleModel> moduleList;
  bool moduleBarVisible;
  bool menuVisible;
  String title;
  UserModel user;

  MainViewFormModel({
    required this.body,
    required this.moduleSelect,
    required this.moduleList,
    required this.moduleBarVisible,
    required this.title,
    required this.menuVisible,
    required this.menuSelect,
    required this.user,
  });

  MainViewFormModel.empty()
      : body = null,
        moduleSelect = 0,
        menuSelect = -1,
        moduleList = [],
        moduleBarVisible = true,
        menuVisible = true,
        title = '',
        user = UserModel.empty();
}
