import 'dart:convert';

import 'package:csv/csv.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../../../models/inventory_row_model.dart';
import '../../../utilities/format.dart';

class WaybillCsv {
  static Future<void> waybillCsvSave(List<InventoryRowModel> waybill) async {
    const String titleFile = 'lista_carta_porte.csv';
    List<String> rowHeader = [
      'Clave',
      'Descripcion',
      'Cantidad',
      'Peso unitario',
      'Valor unitario',
      'Peso total',
      'Valor total',
    ];
    List<List<dynamic>> rows = [];
    List<String> dataRow = [];
    String csv;
    double totalWeight;
    double totalPrice;
    final String warehouseName;

    if (waybill.isNotEmpty) {
      warehouseName = waybill.first.warehouseName;
    } else {
      warehouseName = '';
    }

    rows.add([
      'Almacen: ',
      warehouseName,
      '',
      'Fecha: ',
      FormatDate.dmy(DateTime.now()),
    ]);
    rows.add(rowHeader);
    if (waybill.isNotEmpty) {
      for (var data in waybill) {
        dataRow = [];
        totalPrice = data.product.price * (data.product.weight ?? 0) * data.stock;
        totalWeight = (data.product.weight ?? 0) * data.stock;
        dataRow.add(data.product.code);
        dataRow.add(data.product.description);
        dataRow.add(data.stock.toString());
        dataRow.add(data.product.weight.toString());
        dataRow.add(data.product.price.toString());
        dataRow.add(totalWeight.toString());
        dataRow.add(totalPrice.toString());
        rows.add(dataRow);
      }
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
