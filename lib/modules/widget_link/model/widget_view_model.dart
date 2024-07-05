import '../../object/model/filter_obj_model.dart';

class WidgetViewModel {
  final String key;
  final String name;
  final Map<String, dynamic> properties;
  final List<FilterObjModel> filterList;

  WidgetViewModel({
    required this.name,
    required this.filterList,
    required this.key,
    required this.properties,
  });

  WidgetViewModel.empty()
      : key = '',
        name = '',
        properties = {},
        filterList = [];

  /// Cambia las propiedades del view recibido.
  WidgetViewModel.properties(WidgetViewModel view, this.properties)
      : key = view.key,
        name = view.name,
        filterList = view.filterList;

  static String get tName => 'name';
  static String get tProperties => 'properties';
  static String get propColumnWidth => 'columnWidth';

  /// Estructura view en base de datos:
  /// {"key": {"name": String, "properties": Map<String,String>}}
  static List<WidgetViewModel> mapToViews(Map<String, dynamic> map) {
    List<WidgetViewModel> views = [];

    for (var key in map.keys) {
      if (map[key] is Map<String, dynamic>) {
        views.add(WidgetViewModel(
          key: key,
          name: map[key][tName] ?? '',
          properties: map[key][tProperties] ?? {},
          filterList: [],
          //filterList: FilterObjModel.mapToFilters(map[key]),
        ));
      }
    }
    return views;
  }

  /// Convierte una lista de views en un map.
  static Map<String, dynamic> listToMap(List<WidgetViewModel> list) {
    Map<String, dynamic> map = {};

    for (WidgetViewModel view in list) {
      map[view.key] = {
        WidgetViewModel.tName: view.name,
        WidgetViewModel.tProperties: view.properties,
      };
    }

    return map;
  }
}
