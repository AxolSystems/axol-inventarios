import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../utilities/format.dart';
import '../model/movement_model.dart';

class MovementPdf {
  Future<Uint8List> movementPdf(List<MovementModel> movementList) {
    final pdf = pw.Document();
    const primaryColor = PdfColors.grey300;
    const pw.TextStyle bodyText = pw.TextStyle(fontSize: 8);
    final pw.TextStyle subtitleText10 =
        pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
    final pw.TextStyle subtitleText12 =
        pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);
    final pw.TextStyle titleTextBold =
        pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold);
    final pw.TextStyle titleText =
        pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.normal);
    Map<String, Map<String, List<MovementModel>>> movementMap = {};
    String code;
    //movementMap: {code: {warehouse: List<movment>, ...}, ...}

    for (var movement in movementList) {
      code = '${movement.code}/~${movement.description}';
      if (movementMap.containsKey(code)) {
        if (movementMap[code]!.containsKey(movement.warehouseName)) {
          movementMap[code]![movement.warehouseName]!.add(movement);
        } else {
          movementMap[code]![movement.warehouseName] = [movement];
        }
      } else {
        movementMap[code] = {
          movement.warehouseName: [movement]
        };
      }
    }

    pdf.addPage(pw.MultiPage(
      header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
                height: 90,
                child: pw.Row(children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    width: 100,
                    height: 70,
                    child: pw.Center(child: pw.Text('Logo')),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      'J&J PLASTICOS RECYCLING S DE RL DE CV',
                      style: titleText,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ])),
            pw.Text('Movimientos al inventario',
                style: titleTextBold, textAlign: pw.TextAlign.center),
            pw.Container(
              height: 16,
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      top: pw.BorderSide(
                        color: PdfColors.black,
                        width: 1,
                      ),
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 1,
                      ))),
              child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                  child: pw.Row(children: [
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          'Fecha',
                          style: subtitleText10,
                          textAlign: pw.TextAlign.left,
                        )),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          'Documento',
                          style: subtitleText10,
                          textAlign: pw.TextAlign.left,
                        )),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          'Movimiento',
                          style: subtitleText10,
                          textAlign: pw.TextAlign.left,
                        )),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          'Cantidad',
                          style: subtitleText10,
                          textAlign: pw.TextAlign.right,
                        )),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          'Existencias',
                          style: subtitleText10,
                          textAlign: pw.TextAlign.right,
                        )),
                  ])),
            ),
            pw.SizedBox(height: 8)
          ]),
      footer: (context) => pw.Column(children: [
        pw.SizedBox(height: 8),
        pw.Container(
          height: 16,
          decoration:
              const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide())),
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Fecha: ${FormatDate.dmy(DateTime.now())}',
                    style: bodyText),
                pw.Text('Pág. ${context.pageNumber}', style: bodyText),
              ]),
        ),
      ]),
      build: (context) {
        List<pw.Widget> widgetList = [];

        for (var codeKey in movementMap.keys) {
          widgetList.add(pw.Row(children: [
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                'Producto: ${codeKey.split('/~').first}',
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Text('Descripción: ${codeKey.split('/~').last}',
                  style: bodyText),
            ),
          ]));
          for (var warehouseKey in movementMap[codeKey]!.keys) {
            widgetList.add(pw.Row(children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text('Almacén: num', style: bodyText),
              ),
              pw.Expanded(
                flex: 4,
                child: pw.Text(warehouseKey, style: bodyText),
              ),
            ]));
            for (var movement in movementMap[codeKey]![warehouseKey]!) {
              widgetList.add(pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                  child: pw.Row(children: [
                    pw.Expanded(
                        child: pw.Text(
                      FormatDate.dmy(movement.time),
                      style: bodyText,
                      textAlign: pw.TextAlign.left,
                    )),
                    pw.Expanded(
                        child: pw.Text(
                      movement.document,
                      style: bodyText,
                      textAlign: pw.TextAlign.left,
                    )),
                    pw.Expanded(
                        child: pw.Text(
                      movement.concept.toString(),
                      style: bodyText,
                      textAlign: pw.TextAlign.left,
                    )),
                    pw.Expanded(
                        child: pw.Text(
                      movement.conceptType == 0
                          ? FormatNumber.format2dec(movement.quantity)
                          : '-${FormatNumber.format2dec(movement.quantity)}',
                      style: bodyText,
                      textAlign: pw.TextAlign.right,
                    )),
                    pw.Expanded(
                        child: pw.Text(
                      FormatNumber.format2dec(movement.stock),
                      style: bodyText,
                      textAlign: pw.TextAlign.right,
                    )),
                  ])));
            }
          }
          widgetList.add(pw.SizedBox(height: 8));
        }

        return widgetList;
      },
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
    ));
    return pdf.save();
  }
}
