import 'package:flutter/material.dart';

import '../../../block/model/block_model.dart';
import '../../../block/model/property_model.dart';
import '../../../object/model/filter_obj_model.dart';

class FilterFormModel {
  List<FilterModel> filterList;
  BlockModel block;

  FilterFormModel({required this.filterList, required this.block});

  FilterFormModel.empty()
      : filterList = [],
        block = BlockModel.empty();
}

abstract class FilterModel {
  PropertyModel property;
  List<FilterOperator> operatorList;
  FilterOperator operator;
  FilterModel(
      {required this.property,
      required this.operatorList,
      required this.operator});
}

class AddFilterModel extends FilterModel {
  AddFilterModel()
      : super(
          property: PropertyModel.empty(),
          operatorList: [],
          operator: FilterOperator.eq,
        );
}

class EmptyFilterModel extends FilterModel {
  EmptyFilterModel({
    required super.property,
    required super.operator,
    required super.operatorList,
  });

  EmptyFilterModel.empty()
      : super(
          property: PropertyModel.empty(),
          operator: FilterOperator.eq,
          operatorList: [],
        );
}

class TextFilterModel extends FilterModel {
  TextEditingController ctrlValue;

  TextFilterModel({
    required this.ctrlValue,
    required super.property,
    required super.operatorList,
    required super.operator,
  });

  TextFilterModel.empty()
      : ctrlValue = TextEditingController(),
        super(
            property: PropertyModel.empty(),
            operatorList: [
              FilterOperator.eq,
              FilterOperator.like,
              FilterOperator.ilike
            ],
            operator: FilterOperator.eq);
}
