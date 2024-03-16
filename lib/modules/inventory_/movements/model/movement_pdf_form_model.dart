import 'package:flutter/material.dart';

class MovementPdfFormModel {
  TextEditingController document;
  TextEditingController folio;

  MovementPdfFormModel({
    required this.document,
    required this.folio,
  });

  MovementPdfFormModel.empty()
      : document = TextEditingController(),
        folio = TextEditingController();
}
