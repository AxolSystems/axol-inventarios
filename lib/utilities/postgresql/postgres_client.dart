class PostgresClient {
  static const String urlHttp = 'http://192.168.1.74:3000/api/elements';
  //static const String urlHttp = 'http://localhost:3000/api/elements';
}

class Modules {
  final String tableName = 'modules';
  final String index = 'index_module';
  final String id = 'id_module';
  final String name = 'text';
  final String icon = 'icon';
  final String createAt = 'create_at';
}

class Widgets {
  final String tableName = 'widgets';
  final String index = 'index_widget';
  final String id = 'id_widget';
  final String widget = 'widget';
  final String idEntity = 'id_entity';
  final String idModule = 'id_module';
  final String createAt = 'create_at';
}

class Views {
  final String tableName = 'views';
  final String id = 'id_view';
  final String index = 'index_view';
  final String name = 'name';
  final String dynamicValues = 'dynamic_values';
  final String idWidget = 'id_widget';
  final String createAt = 'create_At';
}

class Entities {
  final String tableName = 'entities';
  final String id = 'id_entity';
  final String table = 'table_name';
  final String entityName = 'entity_name';
  final String createAt = 'create_at';
}

class Properties {
  final String tableName = 'properties';
  final String id = 'id_property';
  final String index = 'index_prop';
  final String columnName = 'column_name';
  final String dataType = 'data_type';
  final String propName = 'prop_name';
  final String dynamicValues = 'dynamic_values';
  final String idEntity = 'id_entity';
  final String createAt = 'create_at';
}

class TableGen {
  final String id = 'id';
  final String createAt = 'create_at';
}

class PsqlTables {
  static Modules get modules => Modules();
  static Widgets get widgets => Widgets();
  static Views get views => Views();
  static Entities get entities => Entities();
  static Properties get properties => Properties();
  static TableGen get tableGen => TableGen();
}
