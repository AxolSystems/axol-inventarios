import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../utilities/format.dart';
import '../../../user/model/user_mdoel.dart';
import '../model/inventory_move/concept_move_model.dart';
import '../model/report_inventory_move_model.dart';
import '../model/report_multimove/report_multimove_model.dart';

class InventoryMovePdf {
  Future<Uint8List> transfer(ReportInventoryMoveModel data) async {
    final pdf = pw.Document();
    const pw.TextStyle title = pw.TextStyle(fontSize: 14);
    const pw.TextStyle bodyText = pw.TextStyle(fontSize: 8);
    final pw.TextStyle subtitleText10 =
        pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);

    pdf.addPage(pw.MultiPage(
      header: (context) => pw.Column(
        children: [
          pw.Text('J&J PLASTICOS RECYCLING S DE RL DE CV', style: title),
          pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Row(children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('        Almacén de origen: ',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                        '${data.warehouse.id} - ${data.warehouse.name}',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Movimiento de salida: ',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('58 - ${ConceptMoveModel.conceptName58}',
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
                        '${data.warehouseDestiny.id} - ${data.warehouseDestiny.name}',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Movimiento de entrada: ',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('7 - ${ConceptMoveModel.conceptName7}',
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
                    child: pw.Text(FormatDate.dmy(data.dateTime),
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Documento: ', style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text(data.document, style: subtitleText10)),
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
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Precio',
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
        double totalRow = 0;
        double price = 0;
        double totalPrice = 0;
        rowList.add(pw.SizedBox(height: 4));
        for (var element in data.productList) {
          totalRow = (element.product.weight ?? 0) * element.quantity;
          total = total + totalRow;
          price = element.product.price * element.quantity * (element.product.weight ?? 0);
          totalPrice = totalPrice + price;
          row = pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            child: pw.Row(children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text(element.quantity.toString(), style: bodyText),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(element.product.code, style: bodyText),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text(element.product.description, style: bodyText),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  '${FormatNumber.format2dec(element.product.weight ?? 0)}  ',
                  style: bodyText,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  FormatNumber.format2dec(totalRow),
                  style: bodyText,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  '\$${FormatNumber.format2dec(price)}',
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
                      'Total: ',
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
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(
                        border: pw.Border(top: pw.BorderSide())),
                    child: pw.Text(
                      '\$${FormatNumber.format2dec(totalPrice)}',
                      style: bodyText,
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ),
              ],
            )));

        return rowList;
      },
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.symmetric(vertical: 24, horizontal: 12),
    ));

    return pdf.save();
  }

  Future<Uint8List> singleMove(ReportInventoryMoveModel data) async {
    final pdf = pw.Document();
    const pw.TextStyle title = pw.TextStyle(fontSize: 14);
    const pw.TextStyle bodyText = pw.TextStyle(fontSize: 8);
    final pw.TextStyle subtitleText10 =
        pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
    String lblDocument = '';
    if (data.concept.type == 0) {
      lblDocument = 'Nota de entrada: ';
    } else if (data.concept.type == 1) {
      lblDocument = 'Nota de salida: ';
    }

    pdf.addPage(pw.MultiPage(
      header: (context) => pw.Column(
        children: [
          pw.Text('J&J PLASTICOS RECYCLING S DE RL DE CV', style: title),
          pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Row(children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('     Concepto: ', style: subtitleText10)),
                pw.Expanded(
                    flex: 4,
                    child: pw.Text('${data.concept.id} - ${data.concept.text}',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1, child: pw.Text('Fecha: ', style: subtitleText10)),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text(FormatDate.dmy(data.dateTime),
                        style: subtitleText10)),
              ])),
          pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Row(children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('     Almacén: ', style: subtitleText10)),
                pw.Expanded(
                    flex: 4,
                    child: pw.Text(
                        '${data.warehouse.id} - ${data.warehouse.name}',
                        style: subtitleText10)),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text(lblDocument, style: subtitleText10)),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text(data.document, style: subtitleText10)),
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
                      child: pw.Text(
                        'Cantidad',
                        style: subtitleText10,
                        textAlign: pw.TextAlign.right,
                      )),
                  pw.SizedBox(width: 12),
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
        double totalRow = 0;
        rowList.add(pw.SizedBox(height: 4));
        for (var element in data.productList) {
          totalRow = (element.product.weight ?? 0) * element.quantity;
          total = total + totalRow;
          row = pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            child: pw.Row(children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  FormatNumber.format2dec(element.quantity),
                  style: bodyText,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                flex: 1,
                child: pw.Text(element.product.code, style: bodyText),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text(element.product.description, style: bodyText),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  '${FormatNumber.format2dec(element.product.weight ?? 0)}  ',
                  style: bodyText,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  FormatNumber.format2dec(totalRow),
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
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.all(24),
    ));

    return pdf.save();
  }

  Future<Uint8List> multiMove(
    ReportMultimoveModel data,
    UserModel user,
    DateTime reportTime,
  ) async {
    final pdf = pw.Document();
    const pw.TextStyle title = pw.TextStyle(fontSize: 14);
    const pw.TextStyle bodyText = pw.TextStyle(fontSize: 8);
    final pw.TextStyle bodyTextBold =
        pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);

    pdf.addPage(pw.MultiPage(
      header: (context) => pw.Column(
        children: [
          pw.Row(children: [
            pw.Container(
              height: 60,
              width: 60,
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Text('Logo'),
            ),
            pw.Expanded(
              child: pw.Text('J&J PLASTICOS RECYCLING S DE RL DE CV',
                  style: title, textAlign: pw.TextAlign.center),
            ),
          ]),
          pw.Text('Resumen de movimientos', style: title),
          pw.Container(
            decoration: const pw.BoxDecoration(
                border:
                    pw.Border.symmetric(horizontal: pw.BorderSide(width: 1))),
            child: pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, top: 4, bottom: 4),
                child: pw.Row(children: [
                  pw.Expanded(
                      flex: 1, child: pw.Text('Fecha: ', style: bodyTextBold)),
                  pw.Expanded(
                      flex: 6,
                      child: pw.Text(
                          '${FormatDate.dmy(data.startTime)} - ${FormatDate.dmy(data.endTime)}',
                          style: bodyText)),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text('    Documento: ', style: bodyTextBold)),
                  pw.Expanded(
                      flex: 8, child: pw.Text(data.document, style: bodyText)),
                ])),
          ),
        ],
      ),
      footer: (context) => pw.Container(
          decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(width: 1))),
          child: pw.Row(children: [
            pw.Expanded(
              flex: 1,
              child: pw.Text('Usuario: ', style: bodyTextBold),
            ),
            pw.Expanded(
              flex: 4,
              child: pw.Text(
                user.name,
                style: bodyText,
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text('      Fecha y hora: ', style: bodyTextBold),
            ),
            pw.Expanded(
              flex: 6,
              child: pw.Text(
                FormatDate.dmyHm(reportTime),
                style: bodyText,
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text('Pág. ${context.pageNumber} ', style: bodyText),
            ),
          ])),
      build: (context) {
        List<pw.Widget> widgetList = [];
        pw.Widget widgetRow;
        pw.Column widgetColumn;
        double totalColQuantity = 0;
        double totalColWeight = 0;

        for (var row in data.rowList) {
          double totalQuantity = 0;
          double totalWeight = 0;

          widgetList.add(pw.SizedBox(height: 4));
          widgetColumn = pw.Column(children: [
            pw.Row(children: [
              pw.Expanded(
                flex: 2,
                child: pw.Text('     Producto: ', style: bodyTextBold),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text(row.product.code, style: bodyText),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text('Descripción: ', style: bodyTextBold),
              ),
              pw.Expanded(
                flex: 9,
                child: pw.Text(row.product.description, style: bodyText),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text('Peso: ', style: bodyTextBold),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                    '${FormatNumber.format2dec(row.product.weight ?? 0)} KG',
                    style: bodyText),
              ),
            ]),
            pw.Row(children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text('Almacén: ', style: bodyTextBold),
              ),
              pw.Expanded(
                flex: 9,
                child: pw.Text('${row.warehouse.id} - ${row.warehouse.name}',
                    style: bodyText),
              ),
            ]),
            pw.Row(children: [
              pw.Expanded(
                flex: 1,
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('Fecha', style: bodyTextBold)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 3,
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('Documento', style: bodyTextBold)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 2,
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('Folio', style: bodyTextBold)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 2,
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('Movimiento', style: bodyTextBold)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 2,
                child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text('Cantidad', style: bodyTextBold)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 2,
                child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text('Peso total', style: bodyTextBold)),
              ),
            ])
          ]);
          for (var subrow in row.subrowList) {
            final subTotalWeight = subrow.quantity * (row.product.weight ?? 0);
            totalQuantity = totalQuantity + subrow.quantity;
            totalWeight = totalWeight + subTotalWeight;
            widgetRow = pw.Row(children: [
              pw.Expanded(
                flex: 1,
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(FormatDate.dmy(subrow.dateTime),
                        style: bodyText)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 3,
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(subrow.document, style: bodyText)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 2,
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(subrow.folio.toString(), style: bodyText)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 2,
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(subrow.concept.text, style: bodyText)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 2,
                child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(FormatNumber.format2dec(subrow.quantity),
                        style: bodyText)),
              ),
              pw.SizedBox(width: 4),
              pw.Expanded(
                flex: 2,
                child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(FormatNumber.format2dec(subTotalWeight),
                        style: bodyText)),
              ),
            ]);
            widgetColumn.children.add(widgetRow);
          }
          widgetColumn.children.add(pw.Row(children: [
            pw.SizedBox(width: 12),
            pw.Expanded(
              flex: 8,
              child: pw.Text(
                'Subtotal: ',
                style: bodyTextBold,
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Expanded(
                flex: 2,
                child: pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(top: pw.BorderSide(width: 0.5)),
                  ),
                  child: pw.Text(
                    FormatNumber.format2dec(totalQuantity),
                    style: bodyText,
                    textAlign: pw.TextAlign.right,
                  ),
                )),
            pw.SizedBox(width: 4),
            pw.Expanded(
                flex: 2,
                child: pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(top: pw.BorderSide(width: 0.5)),
                  ),
                  child: pw.Text(
                    FormatNumber.format2dec(totalWeight),
                    style: bodyText,
                    textAlign: pw.TextAlign.right,
                  ),
                )),
          ]));
          widgetColumn.children.add(
            pw.SizedBox(height: 4),
          );
          widgetList.add(pw.Container(
              decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide())),
              child: widgetColumn));
          totalColQuantity = totalColQuantity + totalQuantity;
          totalColWeight = totalColWeight + totalWeight;
        }
        widgetList.add(pw.Padding(
          padding: const pw.EdgeInsets.only(top: 4),
          child: pw.Row(children: [
            pw.SizedBox(width: 12),
            pw.Expanded(
              flex: 4,
              child: pw.Text(
                'Total: ',
                style: bodyTextBold,
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                FormatNumber.format2dec(totalColQuantity),
                style: bodyText,
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                FormatNumber.format2dec(totalColWeight),
                style: bodyText,
                textAlign: pw.TextAlign.right,
              ),
            ),
          ]),
        ));
        return widgetList;
      },
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.all(24),
    ));

    return pdf.save();
  }
}
