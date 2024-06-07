import '../../block/model/property_model.dart';

enum FilterObj { eq, neq, gt, gte, lt, lte, like, ilike }

class FilterObjModel {
  final PropertyModel property;
  final dynamic value;
  final FilterObj filter;

  FilterObjModel({
    required this.property,
    required this.value,
    required this.filter,
  });
}
