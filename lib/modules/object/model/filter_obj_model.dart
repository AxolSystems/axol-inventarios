import '../../block/model/property_model.dart';

enum FilterOperator { eq, neq, gt, gte, lt, lte, like, ilike }

class FilterObjModel {
  final PropertyModel property;
  final dynamic value;
  final FilterOperator operator;

  FilterObjModel({
    required this.property,
    required this.value,
    required this.operator,
  });

  static String get tProperty => 'property';
  static String get tValue => 'value';
  static String get tFilter => 'filter';
  static List<FilterOperator> get operTextList => [
        FilterOperator.eq,
        FilterOperator.neq,
        FilterOperator.like,
        FilterOperator.ilike,
      ];
  static List<FilterOperator> get operNumberList => [
    FilterOperator.eq,
    FilterOperator.neq,
    FilterOperator.gt,
    FilterOperator.gte,
    FilterOperator.lt,
    FilterOperator.lte,
  ];
  static List<FilterOperator> get operBoolList => [
    FilterOperator.eq,
    FilterOperator.neq,
  ];

  static List<FilterObjModel> mapToFilters(Map<String, dynamic> map) {
    /// Estructura map recibido:
    /// {"n": {"property":int, "value":dynamic, "filter":int}}
    List<FilterObjModel> filters = [];

    for (var value in map.values) {
      if (value is Map<String, dynamic>) {
        filters.add(FilterObjModel(
          property: value[tProperty],
          value: value[tValue],
          operator: value[tFilter],
        ));
      }
    }

    return filters;
  }

  static String operatorToText(FilterOperator operator) {
    switch (operator) {
      case FilterOperator.eq:
        return '=';
      case FilterOperator.gt:
        return '>';
      case FilterOperator.gte:
        return '>=';
      case FilterOperator.like:
        return '~~';
      case FilterOperator.ilike:
        return '~~*';
      case FilterOperator.lt:
        return '<';
      case FilterOperator.lte:
        return '<=';
      case FilterOperator.neq:
        return '<>';
    }
  }
}
