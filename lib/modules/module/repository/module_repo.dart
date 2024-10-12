import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../utilities/postgresql/postgres_client.dart';
import '../../../utilities/postgresql/query_builder.dart';
import '../../widget_link/model/widgetlink_model.dart';
import '../../widget_link/repository/widgetlink_repo.dart';
import '../model/link_widget_module_model.dart';
import '../model/module_model.dart';
import 'links_widget_module_repo.dart';
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

  static const String _uri = PostgresClient.urlHttp;

  ///FETCH MODULES V. 2
  static Future<List<ModuleModel>> fetchModulesPostgres() async {
    List<ModuleModel> moduleList = [];
    List<String> idModules = [];
    List<LinkWidgetModuleModel> links = [];
    List<Map<String, dynamic>> modulesDB;
    /*final QueryBuilder queryModule =
        QueryBuilder().select('*').from(PostgresClient.tableModules);*/
    final String query =
        'SELECT m.id_module, m.text, m.icon, w.id_widget, w.widget, l.index FROM modules m INNER JOIN links_widget_module l ON m.id_module = l.id_module INNER JOIN widgets w ON l.id_widget = w.id_widget';

    //1. Obtiene todos los módulos de la base de datos.
    //Obtener: Todos los módulos, los widgets del modulo seleccionado,
    //las vistas del widget seleccionado, y la entidad del widget seleccionado. 
    final response = await http.post(
      Uri.parse(_uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': query, 'data': []}),
    );

    if (response.statusCode == 200) {
      modulesDB = json.decode(response.body);
    } else {
      throw Exception('Error add new element');
    }

    //2. Convierte json en objetos module_model.

    for (Map<String, dynamic> element in modulesDB) {
      moduleList.add(ModuleModel(
        name: element[ModulesDB.name] ?? '',
        id: element[ModulesDB.id] ?? '',
        icon: element[ModulesDB.icon] ?? -1,
        widgetLinks: [],
        permissions: {},
      ));
    }

    //XXX2. Obtiene lista de objetos LinkWidgetModuleModel.
    /*if (modulesDB.isNotEmpty) {
      for (Map<String,dynamic> element in modulesDB) {
        idModules.add(element[_id]);
      }
    }
    
    links = await LinksWidgetModuleRepo().fetchInModule(idModules);*/

    //XXX3. Convierte los los elementos de modulesDB a objeto modulo.

    return moduleList;
  }

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
