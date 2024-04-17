import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:csv/csv.dart';
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
    Uint8List pdfInBytes = await InventoryMovePdf().transfer(dataReport);
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
    Uint8List pdfInBytes = await InventoryMovePdf().singleMove(dataReport);
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
    final String titleFile =
        'reporte_de_movimientos_${dataReport.document}.pdf';
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
  static Future<void> srpSubSaleCsv(
      List<InventoryRowModel> inventory, SaleReportModel report) async {
    const String titleFile = 'reporte_de_ventas.csv';
    List<List<dynamic>> rows = [];
    List<List<dynamic>> header = [];
    List<List<dynamic>> body = [];
    List<List<dynamic>> footer = [];
    List<String> dataRow = [];
    String csv;
    InventoryRowModel inventoryRow;
    List<InventoryRowModel> inventoryList = [];

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

    //Actualiza inventario
    print('flag1');
    if (report.reportRows.isNotEmpty && inventory.isNotEmpty) {
      for (var element in report.reportRows) {
        final List list = inventory
            .where((x) => x.product.code == element.product.code)
            .toList();
        if (list.length == 1) {
          inventoryRow = list.single;
          final double stock = inventoryRow.stock - element.quantity;
          inventoryRow = InventoryRowModel.setStock(
              inventoryRow: inventoryRow, stock: stock);
          inventoryList.add(inventoryRow);
        }
      }
      print('flag2');
      for (var element in inventory) {
        final int containt = inventoryList
            .indexWhere((x) => x.product.code == element.product.code);
        if (containt == -1) {
          inventoryList.add(element);
        }
      }
      print('flag3');

      inventoryList.sort((a, b) => a.product.code.compareTo(b.product.code));
      
      if (inventoryList.isNotEmpty) {
        for (var data in inventoryList) {
          dataRow = [];
          final double intiStock = inventory
              .firstWhere((x) => x.product.code == data.product.code)
              .stock;
          final double saleQty = report.reportRows
              .firstWhere((x) => x.product.code == data.product.code)
              .quantity;
          final productWeight = (data.product.weight ?? 0) * data.stock;
          final subtotal = data.product.price * data.stock * (data.product.weight ?? 0);
          
          dataRow.add(data.product.code);
          dataRow.add(data.product.description);
          dataRow.add(intiStock.toString());
          dataRow.add(saleQty.toString());
          dataRow.add(data.stock.toString());
          dataRow.add('${data.product.weight ?? 0}');
          dataRow.add(productWeight.toString());
          dataRow.add(data.product.price.toString());
          dataRow.add(subtotal.toString());
          body.add(dataRow);
          print('flag3.5');
        }
      }
    }
    print('flag4');
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
