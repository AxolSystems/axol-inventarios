/*import 'package:axol_inventarios/utilities/format.dart';
import 'package:csv/csv.dart';
import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../model/salereport_model.dart';

class SaleReportCsv {
  static Future<void> srpCsvSave(SaleReportModel report) async {
    const String titleFile = 'reporte_de_ventas.csv';
    List<List<dynamic>> rows = [];
    List<List<dynamic>> header = [];
    List<List<dynamic>> body = [];
    List<List<dynamic>> footer = [];
    List<String> dataRow = [];
    List<int> orderKeys = [0,2,1,5,8,6,7,3,4];
    Map<int,String> clasMap = {
      0: 'BOLSA NEGRA',
      1: 'BOLSA NEGRA EN CAJA',
      2: 'BOLSA NEGRA CONTADA',
      3: 'STRETCH FILM',
      4: 'POLIDUCTO',
      5: 'ROLLO NEGRO EXTRUSION',
      6: 'RESINA BAJA DENSIDAD',
      7: 'BOLSA CAMISETA',
      8: 'BOLSA ALTA DENSIDAD',
    };
    Map<int,List<List<String>>> rowMap = {
      0: [],
      1: [],
      2: [],
      3: [],
      4: [],
      5: [],
      6: [],
      7: [],
      8: [],
    };
    String csv;
    double subtotal;
    double total = 0;

    //Crea encabezado
    header.add([
      'REPORTE DE VENTAS',
      '',
      '',
      '',
      '',
      'Almacen: ',
      report.warehouse.name,
      '',
      'Fecha: ',
      FormatDate.dmy(report.date),
    ]);
    header.add([
      'CLAVE',
      'EMPAQUE',
      'GAL',
      'MEDIDA',
      'CALIBRE',
      'PIEZAS',
      'CLIENTE',
      'CANTIDAD VENDIDO',
      'PRECIO UNITARIO',
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
}*/
