import 'package:axol_inventarios/modules/axol_widget/axol_widget.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';

import '../../object/model/object_model.dart';
import '../../user/model/user_mdoel.dart';
import 'modul_model.dart';

class MainViewFormModel {
  AxolWidget? body;
  int moduleSelect;
  int linkSelect;
  int viewSelect;
  List<ModuleModel> moduleList;
  bool moduleBarVisible;
  bool menuVisible;
  String title;
  UserModel user;
  List<ObjectModel> objects;
  WidgetLinkModel widgetLink;

  MainViewFormModel({
    required this.body,
    required this.moduleSelect,
    required this.moduleList,
    required this.moduleBarVisible,
    required this.title,
    required this.menuVisible,
    required this.linkSelect,
    required this.viewSelect,
    required this.user,
    required this.objects,
    required this.widgetLink,
  });

  MainViewFormModel.empty()
      : body = null,
        moduleSelect = 0,
        linkSelect = 0,
        viewSelect = 0,
        moduleList = [],
        moduleBarVisible = true,
        menuVisible = true,
        title = '',
        user = UserModel.empty(),
        objects = [],
        widgetLink = WidgetLinkModel.empty();
}
