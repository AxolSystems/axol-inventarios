import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/format.dart';
import '../../../sale_report/model/salereport_model.dart';
import '../../../sale_report/model/salereport_row_model.dart';
import '../../../user/model/user_mdoel.dart';
import '../../../user/repository/user_repo.dart';
import '../model/report_inventory_move_model.dart';
import '../model/report_multimove/report_multimove_model.dart';
import '../model/warehouse_model.dart';
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
  static Future<void> invSubSaleCsv(
      List<InventoryRowModel> inventory, SaleReportModel report) async {
    const String titleFile = 'inventario_restando_ventas.csv';
    List<List<dynamic>> rows = [];
    List<List<dynamic>> header = [];
    List<List<dynamic>> body = [];
    List<List<dynamic>> footer = [];
    List<String> dataRow = [];
    String csv;
    InventoryRowModel inventoryRow;
    List<InventoryRowModel> upInventoryList = [];

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
          upInventoryList.add(inventoryRow);
        }
      }
      for (var element in inventory) {
        final int containt = upInventoryList
            .indexWhere((x) => x.product.code == element.product.code);
        if (containt == -1) {
          upInventoryList.add(element);
        }
      }
      upInventoryList.sort((a, b) => a.product.code.compareTo(b.product.code));

      if (upInventoryList.isNotEmpty) {
        for (var data in upInventoryList) {
          dataRow = [];
          final double intiStock = inventory
              .firstWhere(
                (x) => x.product.code == data.product.code,
                orElse: () => InventoryRowModel.empty(),
              )
              .stock;
          final double saleQty = report.reportRows
              .firstWhere(
                (x) => x.product.code == data.product.code,
                orElse: () => SaleReportRowModel.empty(),
              )
              .quantity;
          final productWeight = (data.product.weight ?? 0) * data.stock;
          final subtotal =
              data.product.price * data.stock * (data.product.weight ?? 0);

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
        }
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

  static Future<void> inventoryCsv(
      List<InventoryRowModel> inventory, WarehouseModel warehouse) async {
    const String titleFile = 'inventario.csv';
    List<List<dynamic>> rows = [];
    List<List<dynamic>> header = [];
    List<List<dynamic>> body = [];
    List<List<dynamic>> footer = [];
    List<String> dataRow = [];
    String csv;

    //Crea encabezado
    header.add([
      'Almacen: ',
      warehouse.name,
      'Fecha: ',
      FormatDate.dmy(DateTime.now()),
    ]);
    header.add([
      'CLAVE',
      'DESCRIPCION',
      'STOCK',
    ]);

    if (inventory.isNotEmpty) {
      for (var data in inventory) {
        dataRow = [];

        dataRow.add(data.product.code);
        dataRow.add(data.product.description);
        dataRow.add(data.stock.toString());
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
}
