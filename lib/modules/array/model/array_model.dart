import 'package:flutter/material.dart';

import '../../../utilities/theme/theme.dart';

class ArrayModel {
  final String id;
  final List<String> list;
  final String value;

  ArrayModel({required this.id, required this.list, required this.value});

  ArrayModel.empty()
      : id = '',
        list = [],
        value = '';

  ArrayModel setValue(String value_) =>
      ArrayModel(id: id, list: list, value: value_);

  List<DropdownMenuItem<String>> getItems(int theme) {
    List<DropdownMenuItem<String>> items = [];
    for (String element in list) {
      items.add(DropdownMenuItem(
        value: element,
        child: Text(
          element,
          style: Typo.body(theme),
        ),
      ));
    }
    return items;
  }
}
