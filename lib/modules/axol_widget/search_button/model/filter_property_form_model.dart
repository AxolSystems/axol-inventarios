import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:flutter/material.dart';

class FilterPropFormModel {
  List<PropChecked> propCheckedList;
  List<PropChecked> propCheckedView;
  TextEditingController finderController;

  FilterPropFormModel({
    required this.finderController,
    required this.propCheckedList,
    required this.propCheckedView,
  });

  FilterPropFormModel.empty()
      : propCheckedList = [],
        propCheckedView = [],
        finderController = TextEditingController();
}

class PropChecked {
  PropertyModel property;
  bool checked;

  PropChecked({required this.checked, required this.property});
}
