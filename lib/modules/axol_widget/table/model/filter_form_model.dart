import 'package:flutter/material.dart';

import '../../../block/model/block_model.dart';

class FilterFormModel {
  final List<FilterModel> filterList;
  final BlockModel block;

  FilterFormModel({required this.filterList, required this.block});

  FilterFormModel.empty()
      : filterList = [],
        block = BlockModel.empty();
}

abstract class FilterModel {
  final String value;
  FilterModel({required this.value});
}

class AddFilterModel extends FilterModel {
  AddFilterModel() : super(value: '');
}

class TextFilterModel extends FilterModel {
  final TextEditingController ctrlValue;

  TextFilterModel({required this.ctrlValue, required super.value});

  TextFilterModel.empty()
      : ctrlValue = TextEditingController(),
        super(value: '');
}
