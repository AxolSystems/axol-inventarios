/*import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../../../../utilities/format.dart';
import '../model/sale_note_model.dart';
import '../model/sale_product_model.dart';
import '../view/salenote_pdf.dart';

class SaleFileRepo {
  static Future<void> saleNotePdf(SaleNoteModel saleNote,
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

  static Future<void> saleListCsv(
      List<SaleNoteModel> saleNote) async {
    const String titleFile = 'tabla_de_notas.csv';
    List<List<dynamic>> rows = [];
    List<List<dynamic>> header = [];
    List<List<dynamic>> body = [];
    List<List<dynamic>> footer = [];
    List<String> dataRow = [];
    double totalWight = 0;
    String csv;

    header.add([
      'CLAVE',
      'CLIENTE',
      'NOMBRE CLIENTE',
      'FECHA',
      'IMPORTE',
      'ALMACEN',
      'VENDEDOR',
      'ESTADO',
      'KG'
    ]);

    if (saleNote.isNotEmpty) {
      for (var data in saleNote) {
        final String status;
        if (data.status == 0) {
          status = 'cancelado';
        } else {
          status = 'emitido';
        }

        //product = productList.firstWhere((x) => x.code == );
        totalWight = 0;
        for (var element in data.saleProduct) {
          totalWight = totalWight + ((element.product.weight ?? 0) * element.quantity);
        }

        dataRow = [];

        dataRow.add(data.id.toString());
        dataRow.add(data.customer.id.toString());
        dataRow.add(data.customer.name);
        dataRow.add(FormatDate.dmy(data.date));
        dataRow.add(data.total.toString());
        dataRow.add(data.warehouse.id.toString());
        dataRow.add(data.vendor.name);
        dataRow.add(status);
        dataRow.add(totalWight.toString());
        body.add(dataRow);
      }
    }

    //Llena filas
    rows.addAll(header);
    rows.addAll(body);
    rows.addAll(footer);

    //Carga archivo
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

}*/