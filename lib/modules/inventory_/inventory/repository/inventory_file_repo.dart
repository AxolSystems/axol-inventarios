// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';

import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/format.dart';
import '../../../sale_report/model/salereport_model.dart';
import '../../../user/model/user_mdoel.dart';
import '../../../user/repository/user_repo.dart';
import '../model/report_inventory_move_model.dart';
import '../model/report_multimove/report_multimove_model.dart';
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

  static Future<void> multiMove(ReportMultimoveModel dataReport) async {
    final String titleFile = 'reporte_de_movimientos_${dataReport.document}.pdf';
    final UserModel user = await LocalUser().getLocalUser();
    Uint8List pdfInBytes =
        await InventoryMovePdf().multiMove(dataReport, user, DateTime.now());
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

class InventoryCsv {
  static Future<void> srpSubSaleCsv(List<InventoryRowModel> inventory, SaleReportModel report) async {
    const String titleFile = 'reporte_de_ventas.csv';
    List<List<dynamic>> rows = [];
    List<List<dynamic>> header = [];
    List<List<dynamic>> body = [];
    List<List<dynamic>> footer = [];
    List<String> dataRow = [];
    String csv;
    double subtotal;
    double total = 0;

    //Crea encabezado
    header.add([
      '',
      '',
      '',
      '',
      'Almacen: ',
      report.warehouse.name,
      '',
      'Fecha: ',
      FormatDate.dmy(DateTime.now()),
    ]);
    header.add([
      'CLAVE',
      'DESCRIPCION',
      'STOCK INICIAL',
      'CANTIDAD VENDIDO',
      'STOCK FINAL',
      'PESO UNITARIO',
      'PESO PRODUCTO',
      'PRECIO KG',
      'SUBTOTAL',
    ]);

    //Crea lista de productos vendidos
    if (report.reportRows.isNotEmpty) {
      total = 0;
      for (var data in report.reportRows) {
        dataRow = [];
        subtotal = data.unitPrice * data.quantity;
        dataRow.add(data.product.code);
        dataRow.add(data.product.packing ?? '');
        dataRow.add(data.product.capacity ?? '');
        dataRow.add(data.product.measure ?? '');
        dataRow.add('${data.product.gauge ?? ''}');
        dataRow.add(data.product.pieces ?? '');
        dataRow.add(data.customerName);
        dataRow.add(data.quantity.toString());
        dataRow.add(data.unitPrice.toString());
        dataRow.add(subtotal.toString());
        if (clasMap.containsKey(data.product.class_)) {
          rowMap[data.product.class_]!.add(dataRow);
          total = total + subtotal;
        }
      }
    }
    //ordena las filas
    for (var list in rowMap.values) {
      list.sort((a, b) => a.first.compareTo(b.first));
    }
    //inserta las filas en body
    for (var key in orderKeys) {
      if (rowMap[key]!.isNotEmpty) {
        body.add([clasMap[key]]);
        for (var list in rowMap[key]!) {
          body.add(list);
        }
      }
    }

    //Crea filas de pie de página
    dataRow = [];
    for (int i = 0; i < 8; i++) {
      dataRow.add('');
    }
    dataRow.add('TOTAL = ');
    dataRow.add(total.toString());
    footer.add(dataRow);
    footer.add(['Nota: ', report.note]);

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
}