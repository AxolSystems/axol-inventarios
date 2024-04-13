import '../../inventory_/inventory/model/warehouse_model.dart';
import 'salereport_row_model.dart';

class SaleReportModel {
  final int id;
  final DateTime date;
  final int user;
  final SaleReportRowModel report;
  final WarehouseModel warehouse;
  final String note;

  SaleReportModel({
    required this.date,
    required this.id,
    required this.note,
    required this.report,
    required this.user,
    required this.warehouse,
  });

  SaleReportModel.empty() : 
  date = DateTime(0),
  id = -1,
  note = '',
  report = SaleReportRowModel.empty(),
  user = -1,
  warehouse = WarehouseModel.empty();
}
