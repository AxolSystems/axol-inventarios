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

  /// Devuelve una lista con todos los bloques o tablas en la
  /// base de datos disponibles para almacenar objetos.
  static Future<List<EntityModel>> fetchAllEntitys() async {
    List<Map<String, dynamic>> entitysDB = [];
    List<EntityModel> entityList = [];
    EntityModel entity;

    entitysDB = await _supabase
        .from(table)
        .select<List<Map<String, dynamic>>>('*')
        .order(tableName, ascending: true);

    if (entitysDB.isNotEmpty) {
      for (var element in entitysDB) {
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
