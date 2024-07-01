import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widget_link/model/widgetlink_model.dart';
import '../../widget_link/repository/widgetlink_repo.dart';
import '../model/module_model.dart';
import 'module_data_repo.dart';

/// Pasa y recibe datos de módulos a la base da datos.
class ModuleRepo {
  static const String _table = 'modules';
  static const String _id = 'id';
  static const String _text = 'text';
  static const String _icon = 'icon';
  static const String _permissions = 'permissions';
  static const String _widgetLink = 'widget_link';
  static final _supabase = Supabase.instance.client;

  /// Obtiene de la base de datos todos los módulos creados por el usuario.
  static Future<List<ModuleModel>> fetchModuleList() async {
    List<Map<String, dynamic>> modulesDB;
    List<ModuleModel> moduleList = [];
    ModuleModel module;
    List<String> wlList = [];
    List<String> carryList = [];
    List<WidgetLinkModel> widgetLinks;
    List<WidgetLinkModel> widgetLinksEntry;
    Map<String, List<String>> mapWlId = {};
    Map<String, List<WidgetLinkModel>> mapWl = {};

    modulesDB =
        await _supabase.from(_table).select<List<Map<String, dynamic>>>('*');

    //Enlista todas las id de widgetsLinks en los módulos, sin que los
    // widgetLinks se repitan en la lista. Y mapea los id de los widgetsLinks
    // con sus respectivos módulos.
    if (modulesDB.isNotEmpty) {
      for (var mDB in modulesDB) {
        carryList = [];
        final Map<String, dynamic> map = mDB[_widgetLink];
        for (var value in map.values) {
          if (value is String) {
            carryList.add(value);
          }
        }
        mapWlId[mDB[_id]] = carryList;
        for (String value in map.values) {
          if (wlList.indexWhere((x) => x == value) < 0) {
            wlList.add(value);
          }
        }
      }
      // Obtiene todos los widgetLinks enlistados.
      widgetLinks = await WidgetLinkRepo.fetchWidgetLik(wlList);
      // Pasa los valores de los id de widgetLinks a modelos de datos de
      // widgetLinks en un nuevo map.
      for (String key in mapWlId.keys) {
        widgetLinksEntry = [];
        for (String valueN in mapWlId[key]!) {
          widgetLinksEntry.add(widgetLinks.firstWhere((x) => x.id == valueN));
        }
        mapWl[key] = widgetLinksEntry;
      }

      for (var moduleDB in modulesDB) {
        module = ModuleModel(
            icon: IconsRepo.getIcon(moduleDB[_icon]),
            id: moduleDB[_id],
            widgetLinks: mapWl[moduleDB[_id]] ?? [], //Agregar mapToMenu
            permissions: moduleDB[_permissions],
            name: moduleDB[_text],
            onPressed: () {});
        moduleList.add(module);
      }
    }
    return moduleList;
  }

  /// Actualiza módulo de base de datos con los datos recibidos.
  static Future<void> update(ModuleModel module) async {
    await _supabase.from(_table).update({
      _text: module.name,
      _icon: module.icon.codePoint,
      _permissions: module.permissions,
      _widgetLink: WidgetLinkModel.listToMap(module.widgetLinks),
    }).eq(_id, module.id);
  }

  /// Inserta en base de datos los datos del módulo recibido.
  static Future<void> insert(ModuleModel module) async {
    await _supabase.from(_table).insert({
      _id: module.id,
      _text: module.name,
      _icon: module.icon.codePoint,
      _permissions: {},
      _widgetLink: WidgetLinkModel.listToMap(module.widgetLinks),
    });
  }
}
