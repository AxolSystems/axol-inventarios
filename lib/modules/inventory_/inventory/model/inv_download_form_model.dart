import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class InvDownloadFormModel {
  TextEditingController tfSubstract;
  TextEditingController tfOmit;
  DateTime timeInventory;

  InvDownloadFormModel(
      {required this.tfSubstract,
      required this.tfOmit,
      required this.timeInventory});

  InvDownloadFormModel.empty()
      : tfSubstract = TextEditingController(),
        tfOmit = TextEditingController(),
        timeInventory = DateTime(0);
}
