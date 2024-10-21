import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utilities/postgresql/postgres_client.dart';
import '../../../utilities/postgresql/query_builder.dart';
import '../../entity/model/entity_model.dart';
import '../../entity/model/property_model.dart';
import '../../entity/repository/entity_repo.dart';
import '../model/widget_view_model.dart';
import '../model/widgetlink_model.dart';

/// Conexión a la base de datos para realizar consultas de widgetLinks.
/// Los widgetLinks contienen los datos necesarios para hacer la relación
/// entre módulos, bloques y axolWidgets.
class WidgetLinkRepo {
  static const String _table = 'widget_link';
  static const String _id = 'id';
  static const String _entity = 'entity';
  static const String _widget = 'widget';
  static const String _views = 'views';
  static final _supabase = Supabase.instance.client;

  /// Mediante una lista de cadenas de texto, consulta y devuelve
  /// todos los widgetLinks que coincidan con su id.
  static Future<List<WidgetLinkModel>> fetchWidgetLik(
      List<String> idList) async {
    List<Map<String, dynamic>> wlsDB;
    List<WidgetLinkModel> wlList = [];
    WidgetLinkModel wl;
    EntityModel entity = EntityModel.empty();

    wlsDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>('*, entity:entity(*)')
        .in_(_id, idList);

    if (wlsDB.isNotEmpty) {
      for (var wlDB in wlsDB) {
        final dynamicEntity = wlDB[_entity];
        if (dynamicEntity is Map<String, dynamic> && dynamicEntity.isNotEmpty) {
          entity = EntityModel(
            entityName: dynamicEntity[EntityRepo.entityName].toString(),
            propertyList: PropertyModel.mapToProperty(
                dynamicEntity[EntityRepo.property] ?? {}),
            tableName: dynamicEntity[EntityRepo.tableName],
            uuid: dynamicEntity[EntityRepo.id],
          );
        }
        wl = WidgetLinkModel(
          entity: entity,
          id: wlDB[_id],
          widget: wlDB[_widget],
          views: WidgetViewModel.mapToViews(wlDB[_views]),
        );
        wlList.add(wl);
      }
    }
    return wlList;
  }

  static Future<List<WidgetLinkModel>> fetchAllWidgetLik() async {
    List<Map<String, dynamic>> wlsDB;
    List<WidgetLinkModel> wlList = [];
    WidgetLinkModel wl;
    EntityModel entity = EntityModel.empty();

    wlsDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>('*, entity:entity(*)');

    if (wlsDB.isNotEmpty) {
      for (var wlDB in wlsDB) {
        final dynamicEntity = wlDB[_entity];
        if (dynamicEntity is Map<String, dynamic> && dynamicEntity.isNotEmpty) {
          entity = EntityModel(
            entityName: dynamicEntity[EntityRepo.entityName].toString(),
            propertyList: PropertyModel.mapToProperty(
                dynamicEntity[EntityRepo.property] ?? {}),
            tableName: dynamicEntity[EntityRepo.tableName],
            uuid: dynamicEntity[EntityRepo.id],
          );
        }
        wl = WidgetLinkModel(
          entity: entity,
          id: wlDB[_id],
          widget: wlDB[_widget],
          views: WidgetViewModel.mapToViews(wlDB[_views]),
        );
        wlList.add(wl);
      }
    }
    return wlList;
  }

  /// Actualiza las views proporcionado por widgetLink recibido.
  static Future<void> updateView(WidgetLinkModel link) async {
    await _supabase.from(_table).update(
        {_views: WidgetViewModel.listToMap(link.views)}).eq(_id, link.id);
  }

  /// Actualiza las views proporcionado por widgetLink recibido.
  static Future<void> postgresUpdateView(WidgetViewModel view) async {
    final String dynamicValues = '\'${jsonEncode(view.properties)}\'';
    QueryBuilder queryBuilder = QueryBuilder().update(
        PsqlTables.views.tableName, {
      PsqlTables.views.dynamicValues: dynamicValues
    }).eq(PsqlTables.views.id, view.key);
    await queryBuilder.responseQuery;
  }
}
