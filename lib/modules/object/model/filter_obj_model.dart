import '../../block/model/property_model.dart';

enum FilterOperator { eq, neq, gt, gte, lt, lte, like, ilike }

class FilterObjModel {
  final PropertyModel property;
  final dynamic value;
  final FilterOperator filter;

  FilterObjModel({
    required this.property,
    required this.value,
    required this.filter,
  });

  static String get tProperty => 'property';
  static String get tValue => 'value';
  static String get tFilter => 'filter';

  static List<FilterObjModel> mapToFilters(Map<String, dynamic> map) {  
    /// Estructura map recibido:
    /// {"n": {"property":int, "value":dynamic, "filter":int}}
    List<FilterObjModel> filters = [];

    for (var value in map.values) {
      if (value is Map<String, dynamic>) {
        filters.add(FilterObjModel(
          property: value[tProperty],
          value: value[tValue],
          filter: value[tFilter],
        ));
      }
    }

    return filters;
  }
}
