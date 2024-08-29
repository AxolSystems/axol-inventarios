import 'package:flutter/material.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../array/model/array_model.dart';
import '../../../entity/model/entity_model.dart';
import '../../../entity/model/property_model.dart';
import '../../../object/model/filter_obj_model.dart';
import '../../../object/model/reference_object_model.dart';

class FilterFormModel {
  List<FilterModel> filterList;
  EntityModel entity;

  FilterFormModel({required this.filterList, required this.entity});

  FilterFormModel.empty()
      : filterList = [],
        entity = EntityModel.empty();

  List<DropdownMenuItem> getMenuItem(int index, int theme) {
    List<DropdownMenuItem> items = [];
    for (FilterOperator oper in filterList[index].operatorList) {
      items.add(
        DropdownMenuItem(
          value: oper,
          child: Text(
            FilterObjModel.operatorToText(oper),
            style: Typo.body(theme),
          ),
        ),
      );
    }
    return items;
  }
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

class RefObjFilterModel extends FilterModel {
  ReferenceObjectModel refObjController;
  FilterModel referenceFilter;
  RefObjFilterModel({
    required this.refObjController,
    required this.referenceFilter,
    required super.operator,
    required super.operatorList,
    required super.property,
  });
}

class AtmObjFilterModel extends FilterModel {
  List<FilterModel> filterList;
  AtmObjFilterModel({
    required super.property,
    required super.operatorList,
    required super.operator,
    required this.filterList,
  });
}

class ArrayFilterModel extends FilterModel {
  ArrayModel arrayFilter;
  ArrayFilterModel({
    required super.property,
    required super.operatorList,
    required super.operator,
    required this.arrayFilter,
  });
}
