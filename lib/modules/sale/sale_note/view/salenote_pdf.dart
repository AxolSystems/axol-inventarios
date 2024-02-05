import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:spelling_number/spelling_number.dart';

import '../../../../utilities/format.dart';
import '../model/sale_note_model.dart';
import '../model/sale_product_model.dart';

class SaleNotePDF {
  Future<Uint8List> saleNotePDF(SaleNoteModel saleNote,
      List<SaleProductModel> productList, int saleType) {
    final pdf = pw.Document();
    const primaryColor = PdfColors.grey300;
    const pw.TextStyle bodyText = pw.TextStyle(fontSize: 10);
    final pw.TextStyle subtitleText10 =
        pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final pw.TextStyle subtitleText12 =
        pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);
    double totalWight = 0;
    double totalAmount = 0;
    String saleTypeText = '';
    String charNum = '';
    int cents = 0;

    for (var row in productList) {
      final double weightProduct = row.product.weight ?? 0;
      totalWight = (weightProduct * row.quantity) + totalWight;
      totalAmount = totalAmount + (row.price * row.quantity);
    }

    if (saleType == 0) {
      saleTypeText = 'Nota de venta';
    }
    if (saleType == 1) {
      saleTypeText = 'Remisión';
    }

    charNum = SpellingNumber(lang: 'es').convert(totalAmount);
    cents = (double.parse((totalAmount - totalAmount.toInt()).toStringAsFixed(2)) * 100).toInt();

    pdf.addPage(pw.MultiPage(
      header: (context) =>
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Container(
            height: 90,
            decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: primaryColor))),
            child: pw.Row(children: [
              pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                width: 100,
                height: 70,
                child: pw.Center(child: pw.Text('Logo')),
              ),
              pw.Expanded(
                  child: pw.Column(children: [
                pw.Text('J&J PLASTICOS RECYCLUNG S DE RL DE'),
                pw.Text('JAJ100906LL9', style: bodyText),
                pw.Text('21500', style: bodyText),
                pw.Text('Tel: 665-521-7218 Cel: 665-799-3117', style: bodyText),
                pw.Text('email: bolsasvallelaspalmas@gmail.com',
                    style: bodyText),
              ])),
              pw.VerticalDivider(
                thickness: 1,
                width: 16,
                endIndent: 10,
              ),
              pw.Column(children: [
                pw.Container(
                  color: primaryColor,
                  height: 15,
                  width: 100,
                  child: pw.Text(
                    '$saleTypeText ',
                    textAlign: pw.TextAlign.right,
                    style: subtitleText12,
                  ),
                ),
                pw.Container(
                  color: PdfColors.white,
                  height: 15,
                  width: 100,
                  child:
                      pw.Text('${saleNote.id} ', textAlign: pw.TextAlign.right),
                ),
                pw.Container(
                  color: primaryColor,
                  height: 15,
                  width: 100,
                  child: pw.Text(
                    'Fecha ',
                    textAlign: pw.TextAlign.right,
                    style: subtitleText12,
                  ),
                ),
                pw.Container(
                  color: PdfColors.white,
                  height: 15,
                  width: 100,
                  child: pw.Text(FormatDate.dmy(saleNote.date),
                      textAlign: pw.TextAlign.right),
                ),
              ])
            ])),
        pw.Container(
            height: 30,
            width: double.infinity,
            alignment: pw.Alignment.centerRight,
            decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: primaryColor))),
            child: pw.Text(FormatDate.ddMonthYear(saleNote.date),
                textAlign: pw.TextAlign.right)),
        pw.Container(
            height: 90,
            width: double.infinity,
            alignment: pw.Alignment.centerLeft,
            decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: primaryColor))),
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Nombre: ${saleNote.customer.name}',
                    textAlign: pw.TextAlign.left,
                    style: bodyText,
                  ),
                  pw.Text(
                    'RFC: ${saleNote.customer.rfc ?? ''}',
                    textAlign: pw.TextAlign.left,
                    style: bodyText,
                  ),
                  pw.Text(
                    'Tel: ${saleNote.customer.phoneNumber ?? ''}',
                    textAlign: pw.TextAlign.left,
                    style: bodyText,
                  ),
                  pw.Text(
                    'Domicilio: ${saleNote.customer.intNumber ?? ''}, ${saleNote.customer.outNumber ?? ''}, ${saleNote.customer.street ?? ''}, CP: ${saleNote.customer.postalCode ?? ''}',
                    textAlign: pw.TextAlign.left,
                    style: bodyText,
                  ),
                  pw.Text(
                      'Ciudad: ${saleNote.customer.town ?? ''}, ${saleNote.customer.country ?? ''}',
                      textAlign: pw.TextAlign.left, style: bodyText),
                  pw.Text(
                    'Colonia: ${saleNote.customer.hood ?? ''}',
                    textAlign: pw.TextAlign.left,
                    style: bodyText,
                  ),
                ])),
        pw.Container(
          height: 30,
          width: double.infinity,
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(saleNote.note, style: bodyText),
        ),
        pw.Container(
          height: 30,
          color: primaryColor,
          child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('Cantidad ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('Unidad ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('Clave ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('Descripción ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('Peso ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('Galones ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('Calibre ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('Presentación ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('P/U ', style: bodyText),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('Importe ', style: bodyText),
                ),
              ]),
        ),
      ]),
      footer: (context) =>
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(children: [
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              children: [
                pw.Container(
                  height: 15,
                  alignment: pw.Alignment.center,
                  color: primaryColor,
                  child: pw.Text('Cantidad con letra', style: subtitleText10),
                ),
                pw.Container(
                  height: 15,
                  alignment: pw.Alignment.center,
                  child: pw.Text('${charNum.toUpperCase()} PESOS ${FormatNumber.format2dig(cents)}/100 M.N.', style: bodyText),
                )
              ],
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Column(children: [
              pw.Container(
                  height: 15,
                  color: primaryColor,
                  alignment: pw.Alignment.center,
                  child: pw.Text('Total', style: subtitleText10)),
              pw.Container(
                height: 15,
                color: primaryColor,
                child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('  \$ ', style: bodyText),
                      pw.Expanded(
                          child: pw.Container(
                        height: 15,
                        alignment: pw.Alignment.centerRight,
                        color: PdfColors.white,
                        child: pw.Text(FormatNumber.format2dec(totalAmount), style: bodyText),
                      )),
                      pw.SizedBox(width: 8),
                    ]),
              ),
            ]),
          ),
        ]),
        pw.Row(children: [
          pw.Expanded(
              child: pw.Column(
            children: [
              pw.Container(
                color: primaryColor,
                alignment: pw.Alignment.center,
                child: pw.Text('Vendedor', style: subtitleText10),
              ),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(saleNote.vendor.id.toString(), style: bodyText),
              ),
            ],
          )),
          pw.Expanded(
              child: pw.Column(
            children: [
              pw.Container(
                color: primaryColor,
                alignment: pw.Alignment.center,
                child: pw.Text('Peso', style: subtitleText10),
              ),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text('${FormatNumber.format2dec(totalWight)} KG', style: bodyText),
              ),
            ],
          )),
        ]),
        pw.SizedBox(height: 16),
        pw.Text(
          'DEBO Y PAGARE INCONDICIONALMENTE A LA ORDEN DE J & J PLÁSTICOS RECYCLING S DE RL DE CV EN ESTA CIUDAD O EN CUALQUIER OTRA QUE SE ME REQUIERA EL DÍA ${FormatDate.dmy(saleNote.date)} LA CANTIDAD DE \$ ${FormatNumber.format2dec(totalAmount)} ${charNum.toUpperCase()} PESOS ${FormatNumber.format2dig(cents)}/100 VALOR DE LAS MERCANCÍAS O SERVICIOS RECIBIDOS A MI ENTERA CONFORMIDAD. ESTE PAGARE ES MERCANTIL Y ESTA RECIBIDO POR LA LEY GENERAL DE TÍTULOS Y OPERACIONES DE CRÉDITO EN SUS ARTÍCULOS 172 Y 173 PARTE FINAL POR NO SER PAGARE DOMICILIADO Y ARTÍCULOS CORRELATIVOS QUEDA CONVENIDO QUE EN CASO DE MORA, EL PRESENTE TITULO CAUSARA UN INTERÉS DEL 8% MENSUAL.',
          textAlign: pw.TextAlign.justify,
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.SizedBox(height: 16),
        pw.Container(
          width: double.infinity,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Firma: '),
              pw.Container(
                  height: 15,
                  width: 300,
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()))),
            ],
          ),
        ),
      ]),
      build: (context) {
        List<pw.Widget> rowList = [];
        pw.Widget widget;

        for (var row in productList) {
          widget = pw.Row(children: [
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                FormatNumber.format2dec(row.quantity),
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                row.product.packing ?? '',
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                row.product.code,
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                row.product.description,
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                '${row.product.weight} KG',
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                row.product.capacity ?? '',
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                '${row.product.gauge ?? ''}',
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                row.product.pieces ?? '',
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                FormatNumber.format2dec(row.price),
                style: bodyText,
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                FormatNumber.format2dec(row.price * row.quantity),
                style: bodyText,
              ),
            ),
          ]);
          rowList.add(widget);
          widget = pw.Text(row.note, style: bodyText);
          rowList.add(widget);
        }

        return rowList;
      },
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
    ));
    return pdf.save();
  }
}
