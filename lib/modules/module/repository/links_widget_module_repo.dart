import '../../../utilities/postgresql/query_builder.dart';
import '../model/link_widget_module_model.dart';

class LinksWidgetModuleRepo {
  static const String _table = 'links_widget_module';
  static const String _id = 'id';
  static const String _index = 'index';
  static const String _idWidget = 'id_widget';
  static const String _idModule = 'id_module';
  static const String _createAt = 'create_at';

  /// Recibe una lista de id's de módulos y devuelve las filas
  /// coincidentes.
  Future<List<LinkWidgetModuleModel>> fetchInModule(
      List<String> idModules) async {
    List<LinkWidgetModuleModel> links = [];

    final QueryBuilder query = QueryBuilder()
        .select('*')
        .from(_table)
        .in_(_idWidget, idModules);
    final List<Map<String, dynamic>> response = await query.responseQuery;

    for (Map<String, dynamic> element in response) {
      links.add(LinkWidgetModuleModel(
        createAt: element[_createAt],
        id: element[_id],
        idModule: element[_idModule],
        idWidget: element[_idWidget],
        index: element[_index],
      ));
    }

    return links;
  }
}
