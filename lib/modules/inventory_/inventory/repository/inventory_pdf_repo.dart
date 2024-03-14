// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';

import '../model/report_inventory_move_model.dart';
import '../view/inventory_move_pdf.dart';

class InventoryPdfRepo {
  static Future<void> transferPdf(ReportInventoryMoveModel dataReport) async {
    final String titleFile = 'traspaso_${dataReport.document}.pdf';
    Uint8List pdfInBytes =
        await InventoryMovePdf().transfer(dataReport);
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = titleFile;
    html.document.body!.children.add(anchor);
    anchor.click();
  }

  static Future<void> singleMove(ReportInventoryMoveModel dataReport) async {
    final String titleFile = 'movimiento_${dataReport.document}.pdf';
    Uint8List pdfInBytes =
        await InventoryMovePdf().singleMove(dataReport);
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