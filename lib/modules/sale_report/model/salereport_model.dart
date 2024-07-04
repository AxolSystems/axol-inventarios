import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';

import '../../inventory_/inventory/model/warehouse_model.dart';
import 'salereport_row_model.dart';

class SaleReportModel {
  final int id;
  final DateTime date;
  final int user;
  final List<SaleReportRowModel> reportRows;
  final WarehouseModel warehouse;
  final String note;

  SaleReportModel({
    required this.date,
    required this.id,
    required this.note,
    required this.reportRows,
    required this.user,
    required this.warehouse,
  });

  SaleReportModel.empty()
      : date = DateTime(0),
        id = -1,
        note = '',
        reportRows = [],
        user = -1,
        warehouse = WarehouseModel.empty();

  static Map<String, dynamic> modelToMap(List<SaleReportRowModel> reportList) {
    Map<String, dynamic> map = {};
    SaleReportRowModel report;

    for (int i = 0; i < reportList.length; i++) {
      report = reportList[i];
      map[i.toString()] =
          '${report.product.code}~${report.quantity}~${report.unitPrice}~${report.customerName}';
    }

    return map;
  }

  static List<SaleReportRowModel> mapToModel(Map<String,dynamic> map, List<ProductModel> productList) {
    List<SaleReportRowModel> saleReportRowList = [];
    SaleReportRowModel saleReportRow;
    List<String> split;

    for (var element in map.values.toList()) {
      if (element is String && element.split('~').length == 4) { 
        split = element.split('~');
        saleReportRow = SaleReportRowModel(
          product: productList.where((x) => x.code == split[0]).first,
          quantity: double.tryParse(split[1]) ?? 0,
          unitPrice: double.tryParse(split[2]) ?? 0,
          customerName: split[3],
        );
        saleReportRowList.add(saleReportRow);
      }
    }

    return saleReportRowList;
  }
}
