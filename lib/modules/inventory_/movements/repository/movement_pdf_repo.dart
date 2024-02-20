import 'package:flutter/services.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../model/movement_model.dart';
import '../view/movement_pdf.dart';

class MovementPdfRepo {
  static Future<void> movementPdfSave(List<MovementModel> movementList) async {
    const String titleFile = 'movimientos.pdf';

    Uint8List pdfInBytes = await MovementPdf().movementPdf(movementList);
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = titleFile;
    html.document.body!.children.add(anchor);
    anchor.click();
  }
}
