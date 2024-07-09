import 'package:flutter/material.dart';

class RowDetailsFormModel {
  Map<String, TextEditingController> controllers;
  bool edit;

  RowDetailsFormModel({
    required this.controllers,
    required this.edit,
  });

  RowDetailsFormModel.empty()
      : controllers = {},
        edit = false;
}
