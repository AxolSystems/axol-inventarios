import '../../object/model/filter_obj_model.dart';

class WidgetViewModel {
  final String key;
  final String name;
  final List<FilterObjModel> filterList;

  WidgetViewModel(
      {required this.name, required this.filterList, required this.key});

  WidgetViewModel.empty()
      : key = '',
        name = '',
        filterList = [];

  static String get tName => 'name';
  static String get tProperties => 'properties';

  /// Estructura view en base de datos:
  /// {"key": {"name": String, "properties": Map<String,String>}}
  static List<WidgetViewModel> mapToViews(Map<String, dynamic> map) {
    List<WidgetViewModel> views = [];

    for (var key in map.keys) {
      if (map[key] is Map<String, dynamic>) {
        views.add(WidgetViewModel(
          key: key,
          name: map[key][tName] ?? '',
          filterList: [],
          //filterList: FilterObjModel.mapToFilters(map[key]),
        ));
      }
    }
    return views;
  }
}
