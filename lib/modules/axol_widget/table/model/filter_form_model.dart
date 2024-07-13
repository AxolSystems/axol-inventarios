import 'package:flutter/material.dart';

import '../../../block/model/block_model.dart';
import '../../../block/model/property_model.dart';

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
  FilterModel({required this.property});
}

class AddFilterModel extends FilterModel {
  AddFilterModel() : super(property: PropertyModel.empty());
}

class EmptyFilterModel extends FilterModel {
  EmptyFilterModel({required super.property});
  
  EmptyFilterModel.empty() : super(property: PropertyModel.empty());
}

class TextFilterModel extends FilterModel {
  final TextEditingController ctrlValue;

  TextFilterModel({required this.ctrlValue, required super.property});

  TextFilterModel.empty()
      : ctrlValue = TextEditingController(),
        super(property: PropertyModel.empty());
}
