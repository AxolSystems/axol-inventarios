import '../../object/model/filter_obj_model.dart';

class WidgetViewModel {
  final String name;
  final List<FilterObjModel> filterList;

  WidgetViewModel({required this.name, required this.filterList});

  WidgetViewModel.empty()
      : name = '',
        filterList = [];

  /// Estructura view en base de datos:
  /// {"name": {"n":{"property":int, "value":dynamic, "filter":int}}}
  static List<WidgetViewModel> mapToViews(Map<String, dynamic> map) {
    List<WidgetViewModel> views = [];

    for (var key in map.keys) {
      if (map[key] is Map<String, dynamic>) {
        views.add(WidgetViewModel(
            name: key, filterList: FilterObjModel.mapToFilters(map[key])));
      }
    }
    return views;
  }
}
