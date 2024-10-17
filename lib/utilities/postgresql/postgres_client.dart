class PostgresClient {
  //static const String urlHttp = 'http://192.168.1.74:3000/api/elements';
  static const String urlHttp = 'http://localhost:3000/api/elements';

}

class ModulesDB {
    static const String tableName = 'modules';
    static const String index = 'index_module';
    static const String id = 'id_module';
    static const String name = 'text';
    static const String icon = 'icon';
    static const String createAt = 'create_at'; 
  }

class WidgetsDB {
  static const String tableName = 'widgets';
  static const String index = 'index_widget';
  static const String id = 'id_widget';
  static const String widget = 'widget';
  static const String idEntity = 'id_entity';
  static const String idModule = 'id_module';
  static const String createAt = 'create_at';
}

class ViewsDB {
  static const String tableName = 'views';
  static const String id = 'id_view';
  static const String index = 'index_view';
  static const String name = 'name';
  static const String dynamicValues = 'dynamic_values';
  static const String idWidget = 'id_widget';
  static const String createAt = 'create_At';
}

class EntitiesDB {
  static const String tableName = 'entities';
  static const String id = 'id_entity';
  static const String table = 'table_name';
  static const String entityName = 'entity_name';
  static const String createAt = 'create_at';
}

class PropertiesDB {
  static String tableName = 'properties';
  static String id = 'id_property';
  static String index = 'index_prop';
  static String columnName = 'column_name';
  static String dataType = 'data_type';
  static String propName = 'prop_name';
  static String dynamicValues = 'dynamic_values';
  static String idEntity = 'id_entity';
  static String createAt = 'create_at';
}