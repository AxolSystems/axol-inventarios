import 'dart:convert';

import 'package:axol_inventarios/utilities/format.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
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

class MovementCsvRepo {
  static Future<void> movementCsvSave(List<MovementModel> movementList) async {
    const String titleFile = 'movimientos.csv';
    List<String> rowHeader = [
      'Folio',
      'Almacen',
      'Documento',
      'Clave',
      'Descripcion',
      'Concepto',
      'Fecha',
      'Cantidad',
      'Existencias',
    ];
    List<List<dynamic>> rows = [];
    List<String> dataRow = [];
    String csv;

    rows.add(rowHeader);
    for (var data in movementList) {
      dataRow = [];
      dataRow.add(data.folio.toString());
      dataRow.add(data.warehouseName);
      dataRow.add(data.document);
      dataRow.add(data.code);
      dataRow.add(data.description);
      dataRow.add(data.concept.toString());
      dataRow.add(FormatDate.dmy(data.time));
      dataRow.add(data.quantity.toString());
      dataRow.add(data.stock.toString());
      rows.add(dataRow);
    }
    csv = const ListToCsvConverter().convert(rows);

    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes], 'application/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = titleFile;
    html.document.body!.children.add(anchor);
    anchor.click();
  }
}
