import 'package:flutter/widgets.dart';

class InvDownloadFormModel {
  TextEditingController controller;
  
  InvDownloadFormModel({required this.controller});

  InvDownloadFormModel.empty() : 
  controller = TextEditingController();
}