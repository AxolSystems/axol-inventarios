import 'package:axol_inventarios/modules/entity/model/entity_model.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utilities/postgresql/postgres_client.dart';
import '../../../utilities/postgresql/query_builder.dart';
import '../../widget_link/model/widget_view_model.dart';
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

  ///FETCH MODULES V. 2
  static Future<List<ModuleModel>> fetchModulesPostgres() async {
    List<ModuleModel> moduleList = [];
    List<Map<String, dynamic>> modulesDB = [];
    List<Map<String, dynamic>> entitiesDB = [];
    List<WidgetViewModel> viewList = [];
    List<WidgetLinkModel> widgetList = [];
    List<PropertyModel> propertyList = [];
    String entityIdsText = '';
    EntityModel entity;

    const String query =
        'SELECT m.id_module, m.index_module, m.text, m.icon, w.id_widget, w.index_widget, w.widget,w.id_entity,v.id_view, v.index_view, v.name, v.dynamic_values FROM modules m LEFT JOIN widgets w ON m.id_module = w.id_module AND m.index_module = 0 LEFT JOIN views v ON w.id_widget = v.id_widget';
    QueryBuilder queryBuilder = QueryBuilder();

    //1. Obtiene Map con módulos, widgets y vistas.
    queryBuilder.query = query;
    modulesDB = await queryBuilder.responseQuery;

    //2. Mapea el contenido de modulesDB por id.
    Map<String, Map<String, Map<String, dynamic>>> mapM = {};
    for (Map<String, dynamic> item in modulesDB) {
      final idM = item[ModulesDB.id];
      final idW = item[WidgetsDB.id];
      final idV = item[ViewsDB.id];

      mapM[idM] ??= {};
      if (idW != null) {
        mapM[idM]?[idW] ??= {};
        if (idV != null) {
          mapM[idM]![idW]![idV] = null;
        }
      }
    }
    //print(modulesDB);

    //3. Obtiene lista de entidades relacionados a los widgets
    for (String keyM in mapM.keys) {
      for (String keyW in mapM[keyM]!.keys) {
        if (entityIdsText == '') {
          entityIdsText =
              '\'${modulesDB.firstWhere((x) => x[WidgetsDB.id] == keyW)[WidgetsDB.idEntity] ?? ''}\'';
        } else {
          entityIdsText =
              '$entityIdsText,\'${modulesDB.firstWhere((x) => x[WidgetsDB.id] == keyW)[WidgetsDB.idEntity] ?? ''}\'';
        }
      }
    }

    queryBuilder.query =
        'SELECT * FROM entities e INNER JOIN properties p ON e.id_entity = p.id_entity WHERE e.id_entity IN ($entityIdsText)';
    entitiesDB = await queryBuilder.responseQuery;
    //print(entitiesDB);

    for (Map<String, dynamic> element in entitiesDB) {
      propertyList.add(PropertyModel(
        name: element[PropertiesDB.propName],
        propertyType:
            PropertyModel.getPropToInt(element[PropertiesDB.dataType]),
        key: element[PropertiesDB.columnName],
        dynamicValues: element[PropertiesDB.dynamicValues] ?? {},
      ));
    }

    entity = EntityModel(
      entityName: entitiesDB.first[EntitiesDB.entityName],
      propertyList: propertyList,
      tableName: entitiesDB.first[EntitiesDB.table],
      uuid: entitiesDB.first[EntitiesDB.id],
    );

    //Crea objetos module.
    for (String keyM in mapM.keys) {
      widgetList = [];
      for (String keyW in mapM[keyM]!.keys) {
        viewList = [];
        for (String keyV in mapM[keyM]![keyW]!.keys) {
          viewList.add(WidgetViewModel(
              name: modulesDB
                  .firstWhere((x) => x[ViewsDB.id] == keyV)[ViewsDB.name],
              filterList: [],
              key: keyV,
              properties: {}));
        }
        widgetList.add(WidgetLinkModel(
          id: modulesDB
              .firstWhere((x) => x[WidgetsDB.id] == keyW)[WidgetsDB.id],
          entity: entity,
          widget: modulesDB
              .firstWhere((x) => x[WidgetsDB.id] == keyW)[WidgetsDB.widget],
          views: viewList,
        ));
      }
      moduleList.add(ModuleModel(
        name: modulesDB
            .firstWhere((x) => x[ModulesDB.id] == keyM)[ModulesDB.name],
        id: modulesDB.firstWhere((x) => x[ModulesDB.id] == keyM)[ModulesDB.id],
        icon: IconsRepo.getIcon(modulesDB
            .firstWhere((x) => x[ModulesDB.id] == keyM)[ModulesDB.icon]),
        widgetLinks: widgetList,
        permissions: {},
      ));
    }
    //print(moduleList.first.widgetLinks.first.views[1].name);

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
