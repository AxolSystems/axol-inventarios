import 'package:flutter/material.dart';

import '../../../entity/model/entity_model.dart';
import '../../../entity/model/property_model.dart';
import '../../../object/model/filter_obj_model.dart';

class FilterFormModel {
  List<FilterModel> filterList;
  EntityModel entity;

  FilterFormModel({required this.filterList, required this.entity});

  FilterFormModel.empty()
      : filterList = [],
        entity = EntityModel.empty();
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
            operatorList: FilterObjModel.operTextList,
            operator: FilterOperator.eq);
}

class NumberFilterModel extends FilterModel {
  TextEditingController ctrlValue;

  NumberFilterModel({
    required this.ctrlValue,
    required super.property,
    required super.operatorList,
    required super.operator,
  });

  NumberFilterModel.empty()
      : ctrlValue = TextEditingController(),
        super(
          property: PropertyModel.empty(),
          operatorList: FilterObjModel.operNumberList,
          operator: FilterOperator.eq,
        );
}

class BooleanFilterModel extends FilterModel {
  bool value;

  BooleanFilterModel({
    required this.value,
    required super.property,
    required super.operatorList,
    required super.operator,
  });

  BooleanFilterModel.empty()
      : value = false,
        super(
          property: PropertyModel.empty(),
          operatorList: FilterObjModel.operNumberList,
          operator: FilterOperator.eq,
        );
}

class DateFilterModel extends FilterModel {
  DateTime dateTime;

  DateFilterModel({
    required this.dateTime,
    required super.property,
    required super.operatorList,
    required super.operator,
  });

  DateFilterModel.init()
      : dateTime = DateTime.now(),
        super(
          property: PropertyModel.empty(),
          operatorList: FilterObjModel.operNumberList,
          operator: FilterOperator.eq,
        );
}