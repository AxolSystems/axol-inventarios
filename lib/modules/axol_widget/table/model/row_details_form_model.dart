import 'package:flutter/material.dart';

class RowDetailsFormModel {
  Map<String,TextEditingController> controllers;

  RowDetailsFormModel({required this.controllers});

  RowDetailsFormModel.empty() : controllers = {};
}
