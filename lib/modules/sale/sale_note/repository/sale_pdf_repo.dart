// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';

import '../model/sale_note_model.dart';
import '../model/sale_product_model.dart';
import '../view/salenote_pdf.dart';

class SalePdfRepo {
  static Future<void> saleNoteSave(SaleNoteModel saleNote,
      List<SaleProductModel> productList, int saleType) async {
    final String titleFile;
    if (saleType == 0) {
      titleFile = 'nota_venta_${saleNote.id}.pdf';
    } else if (saleType == 1) {
      titleFile = 'remision_${saleNote.id}.pdf';
    } else {
      titleFile = '';
    }
    Uint8List pdfInBytes =
        await SaleNotePDF().saleNotePDF(saleNote, productList, saleType);
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