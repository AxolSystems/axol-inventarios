import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../utilities/format.dart';
import '../model/inventory_move/inventory_move_model.dart';
import '../model/warehouse_model.dart';

class InventoryMovePdf {
  Future<Uint8List> inventoryMovePdf(
    InventoryMoveModel inventoryMove,
    WarehouseModel warehouse,
  ) async {
    final pdf = pw.Document();
    const pw.TextStyle title = pw.TextStyle(fontSize: 14);
    const pw.TextStyle bodyText = pw.TextStyle(fontSize: 8);
    final pw.TextStyle subtitleText10 =
        pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);

    pdf.addPage(pw.MultiPage(
      header: (context) => pw.Column(
        children: [
          pw.Text('J&J PLASTICOS RECYCLUNG S DE RL DE CV', style: title),
          pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Row(children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('        Almacén de origen: ',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text('${warehouse.id} - ${warehouse.name}',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Movimiento de salida: ',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                        '58 - ${inventoryMove.concepts.where((x) => x.id == 58).first.text}',
                        style: subtitleText10)),
              ])),
          pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Row(children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('        Almacén destino: ',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                        '${inventoryMove.invTransfer.id} - ${inventoryMove.invTransfer.name}',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Movimiento de entrada: ',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                        '7 - ${inventoryMove.concepts.where((x) => x.id == 7).first.text}',
                        style: subtitleText10)),
              ])),
          pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Row(children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('        Fecha: ', style: subtitleText10)),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text(FormatDate.dmy(inventoryMove.date), style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Documento: ', style: subtitleText10)),
                pw.Expanded(
                    flex: 1, child: pw.Text(inventoryMove.document, style: subtitleText10)),
              ])),
          pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: const pw.BoxDecoration(
                  border: pw.Border.symmetric(horizontal: pw.BorderSide())),
              child: pw.Row(
                children: [
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('Cantidad', style: subtitleText10)),
                  pw.Expanded(
                      flex: 1, child: pw.Text('Clave', style: subtitleText10)),
                  pw.Expanded(
                      flex: 3,
                      child: pw.Text('Descripción', style: subtitleText10)),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Peso unitario',
                        style: subtitleText10,
                        textAlign: pw.TextAlign.center,
                      )),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Peso producto',
                        style: subtitleText10,
                        textAlign: pw.TextAlign.center,
                      )),
                ],
              )),
        ],
      ),
      build: (context) {
        List<pw.Widget> rowList = [];
        pw.Widget row;
        double total = 0;
        rowList.add(pw.SizedBox(height: 4));
        for (var move in inventoryMove.moveList) {
          total = total + move.weightTotal;
          row = pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            child: pw.Row(children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text(move.quantityTf.text, style: bodyText),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(move.product.code, style: bodyText),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text(move.product.description, style: bodyText),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  '${FormatNumber.format2dec(move.weightUnit)}  ',
                  style: bodyText,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  FormatNumber.format2dec(move.weightTotal),
                  style: bodyText,
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ]),
          );
          rowList.add(row);
        }
        rowList.add(pw.SizedBox(height: 4));
        rowList.add(pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            child: pw.Row(
              children: [
                pw.Expanded(flex: 5, child: pw.SizedBox()),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'Peso total: ',
                      style: subtitleText10,
                      textAlign: pw.TextAlign.right,
                    )),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(
                        border: pw.Border(top: pw.BorderSide())),
                    child: pw.Text(
                      FormatNumber.format2dec(total),
                      style: bodyText,
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ),
              ],
            )));

        return rowList;
      },
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
    ));

    return pdf.save();
  }
}
