import '../../axol_widget/table/model/filter_form_model.dart';
import '../../entity/model/property_model.dart';
import 'object_model.dart';
import 'reference_object_model.dart';

enum FilterOperator { eq, neq, gt, gte, lt, lte, like, ilike }

class FilterObjModel {
  final PropertyModel property;
  final PropertyModel? propertyRef;
  final ReferenceObjectModel? refObject;
  final dynamic value;
  final FilterOperator operator;

  FilterObjModel({
    required this.property,
    required this.value,
    required this.operator,
    this.propertyRef,
    this.refObject,
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
  static List<FilterOperator> get operDateTimeList => [
        FilterOperator.eq,
        FilterOperator.neq,
        FilterOperator.gt,
        FilterOperator.gte,
        FilterOperator.lt,
        FilterOperator.lte,
      ];

  FilterObjModel setProperty(PropertyModel propertyRef_) => FilterObjModel(
        operator: operator,
        value: value,
        property: property,
        propertyRef: propertyRef_,
      );

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

  static List<FilterObjModel> filterToObjFilter(List<FilterModel> filterList) {
    List<FilterObjModel> filterObjList = [];
    FilterObjModel filter;
    dynamic value;
    for (FilterModel flt in filterList) {
      if (flt is TextFilterModel) {
        value = flt.ctrlValue.text;
      } else if (flt is NumberFilterModel) {
        value = flt.ctrlValue.text;
      } else if (flt is BooleanFilterModel) {
        value = flt.value;
      } else if (flt is DateFilterModel) {
        value = flt.dateTime.millisecondsSinceEpoch;
      } else if (flt is RefObjFilterModel) {
        final FilterModel fltRef = flt.referenceFilter;
        if (fltRef is TextFilterModel) {
          value = fltRef.ctrlValue.text;
        } else if (fltRef is NumberFilterModel) {
          value = fltRef.ctrlValue.text;
        } else if (fltRef is BooleanFilterModel) {
          value = fltRef.value;
        } else if (fltRef is DateFilterModel) {
          value = fltRef.dateTime.millisecondsSinceEpoch;
        }
      } else if (flt is AtmObjFilterModel) {
        value = flt.filterList;
      }
      if (flt is! EmptyFilterModel && flt is! AddFilterModel) {
        if (flt is RefObjFilterModel) {
          final RefObjFilterModel refObjFilter = flt;
          filter = FilterObjModel(
              property: flt.property,
              value: value,
              operator: flt.operator,
              refObject: ReferenceObjectModel(
                  idPropertyView: refObjFilter.refObjController.idPropertyView,
                  referenceLink: refObjFilter.refObjController.referenceLink,
                  referenceObject: ObjectModel(
                      id: '',
                      map: {
                        refObjFilter.refObjController.getPropView().key: value
                      },
                      createAt: DateTime(0))));
          filterObjList.add(filter);
        } else {
          filter = FilterObjModel(
              property: flt.property, value: value, operator: flt.operator);
          filterObjList.add(filter);
        }
      }
    }
    return filterObjList;
  }
}
