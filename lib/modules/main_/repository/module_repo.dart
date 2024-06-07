import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/modul_model.dart';

class ModuleRepo {
  static const String _table = 'modules';
  static const String _id = 'id';
  static const String _text = 'text';
  static const String _icon = 'icon';
  static const String _permissions = 'permissions';
  static const String _widgetView = 'widget_view';
  static final _supabase = Supabase.instance.client;

  static Future<List<ModuleModel>> fetchModuleList() async {
    List<Map<String, dynamic>> modulesDB;
    List<ModuleModel> moduleList = [];
    ModuleModel module;

    modulesDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>('*');

    if (modulesDB.isNotEmpty) {
      for (var moduleDB in modulesDB) {
        module = ModuleModel(
          icon: moduleDB[_icon],//Agregar intToIcon
          id: moduleDB[_id],
          menu: moduleDB[_widgetView],//Agregar mapToMenu
          permissions: moduleDB[_permissions],
          text: moduleDB[_text],
          widget: moduleDB[_widgetView], //Cambiar por widget
          onPressed: () {}
        );
        wlList.add(wl);
      }
    }

    return wlList;
  }
}
