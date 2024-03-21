import 'package:flutter/material.dart';

import '../../../../utilities/format.dart';

class MovementPdfFormModel {
  TextEditingController document;
  TextEditingController folio;
  TextEditingController concept;
  DateTime startTime;
  DateTime endTime;
  bool filterDate;

  MovementPdfFormModel({
    required this.document,
    required this.folio,
    required this.concept,
    required this.startTime,
    required this.endTime,
    required this.filterDate,
  });

  MovementPdfFormModel.empty()
      : document = TextEditingController(),
        folio = TextEditingController(),
        concept = TextEditingController(),
        startTime = FormatDate.startDay(DateTime.now()),
        endTime = FormatDate.endDay(DateTime.now()),
        filterDate = false;
}
