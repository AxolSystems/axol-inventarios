import 'package:flutter/widgets.dart';

class InvDownloadFormModel {
  TextEditingController controller;
  DateTime timeInventory;
  
  InvDownloadFormModel({required this.controller, required this.timeInventory});

  InvDownloadFormModel.empty() : 
  controller = TextEditingController(),
  timeInventory = DateTime(0);
}