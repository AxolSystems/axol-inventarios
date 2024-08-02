import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/entity_model.dart';

/// Conexión a base de datos para realizar las distintas consultas desde
/// la aplicación. Este repositorio solo tiene acceso a las tablas dedicadas
/// a almacenamiento de objetos.
class EntityRepo {
  static const String table = 'entity';
  static const String id = 'id';
  static const String tableName = 'table_name';
  static const String entityName = 'entity_name';
  static const String property = 'property';
  static final _supabase = Supabase.instance.client;

  /// Devuelve una lista con todas las entidades en la
  /// base de datos disponibles para almacenar objetos.
  static Future<List<EntityModel>> fetchAllEntities() async {
    List<Map<String, dynamic>> entitiesDB = [];
    List<EntityModel> entityList = [];
    EntityModel entity;

    entitiesDB = await _supabase
        .from(table)
        .select<List<Map<String, dynamic>>>('*')
        .order(tableName, ascending: true);

    if (entitiesDB.isNotEmpty) {
      for (var element in entitiesDB) {
        entity = EntityModel(
          entityName: element[entityName] ?? '',
          propertyList: PropertyModel.mapToProperty(element[property] ?? {}),
          tableName: element[tableName] ?? '',
          uuid: element[id].toString(),
        );
        entityList.add(entity);
      }
    }

    return entityList;
  }

  static Future<List<EntityModel>> fetchEntities(List<String> idList) async {
    List<Map<String, dynamic>> entitiesDB = [];
    List<EntityModel> entityList = [];
    EntityModel entity;

    entitiesDB = await _supabase
        .from(table)
        .select<List<Map<String, dynamic>>>('*')
        .in_(id, idList);

    if (entitiesDB.isNotEmpty) {
      for (var element in entitiesDB) {
        entity = EntityModel(
          entityName: element[entityName] ?? '',
          propertyList: PropertyModel.mapToProperty(element[property] ?? {}),
          tableName: element[tableName] ?? '',
          uuid: element[id].toString(),
        );
        entityList.add(entity);
      }
    }

    return entityList;
  }

  /// Recibe el bloque que se usara para actualizar el bloque
  /// con la misma id.
  static Future<void> update(EntityModel entity) async {
    await _supabase.from(table).update({
      entityName: entity.entityName,
      property: EntityModel.propsToMap(entity.propertyList),
    }).eq(id, entity.uuid);
  }
}
