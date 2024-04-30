import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../../utilities/theme/theme.dart';
import '../../model/movement_model.dart';

class PdfMovementsFormats {
  Future<Uint8List> pdfMovements(List<MovementModel> movements) async {
    final pdf = pw.Document();
    List<pw.Row> content = [];
    for (var element in movements) {
      content.add(
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.warehouseName),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.document),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.code),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.description),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.concept.toString()),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(
                '${element.time.day}/${element.time.month}/${element.time.year}'),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.quantity.toString()),
          ),
        ),
      ]));
    }
    //final ByteData bytes = await rootBundle.load('assets/phone.png');
    //final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(pw.MultiPage(
        header: (context) => pw.Column(children: [
              pw.Header(text: "Historial de movimientos", level: 1),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Almacén'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Documento'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Clave'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Descripción'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Concepto'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Fecha'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Cantidad'),
                      ),
                    ),
                  ]),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
            ]),
        footer: (context) => pw.Text('${context.pageNumber}'),
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.letter,
        build: (context) {
          return [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: content),
          ];
        }));
    return pdf.save();
  }

  Future<Uint8List> pdfHistory(List<MovementModel> movements) async {
    final pdf = pw.Document();
    //Fuente de letra:
    //final font = await PdfGoogleFonts.nunitoExtraLight();
    List<pw.Row> content = [];
    for (var element in movements) {
      content.add(
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.warehouseName),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.document),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.code),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.description),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.concept.toString()),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(
                '${element.time.day}/${element.time.month}/${element.time.year}'),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: element.conceptType == 0
                ? pw.Text(element.quantity.toString())
                : pw.Text('-${element.quantity}'),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Center(
            child: pw.Text(element.stock.toString()),
          ),
        ),
      ]));
    }
    //final ByteData bytes = await rootBundle.load('assets/phone.png');
    //final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(pw.MultiPage(
        header: (context) => pw.Column(children: [
              pw.Header(text: "Historial de movimientos", level: 1),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Almacén'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Documento'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Clave'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Descripción'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Concepto'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Fecha'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Cantidad'),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                        child: pw.Text('Existencias'),
                      ),
                    ),
                  ]),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
            ]),
        footer: (context) => pw.Text('${context.pageNumber}'),
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.letter,
        build: (context) {
          return [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: content),
          ];
        }));
    return pdf.save();
  }
}
