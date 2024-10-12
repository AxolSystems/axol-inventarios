class PostgresClient {
  static const String urlHttp = 'http://192.168.1.74:3000/api/elements';
  //static const String urlHttp = 'http://localhost:3000/api/elements';

}

class ModulesDB {
    static const String tableName = 'modules';
    static const String id = 'id_module';
    static const String name = 'text';
    static const String icon = 'icon';
    static const String createAt = 'create_at'; 
  }

class WidgetsDB {
  static const String tableName = 'widgets';
  static const String id = 'id_widget';
  static const String widget = 'widget';
  static const String idEntity = 'id_entity';
  static const String createAt = 'create_at';
}

class LinksWidgetModuleDB {
  static const String tablaName = 'links_widget_module';
  static const String id = 'id_link';
  static const String index = 'index';
  static const String idWidget = 'id_widget';
  static const String idModule = 'id_module';
  static const String createAt = 'create_at';
}