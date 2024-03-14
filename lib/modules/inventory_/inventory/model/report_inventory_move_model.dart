import 'inventory_move/concept_move_model.dart';
import 'inventory_move/inventory_move_row_model.dart';
import 'report_inventory_row_model.dart';
import 'warehouse_model.dart';

class ReportInventoryMoveModel {
  final WarehouseModel warehouse;
  final List<WarehouseModel> warehouseList;
  final WarehouseModel warehouseDestiny;
  final String document;
  final DateTime dateTime;
  final List<ReportInventoryRowModel> productList;
  final ConceptMoveModel concept;

  const ReportInventoryMoveModel({
    required this.warehouse,
    required this.dateTime,
    required this.document,
    required this.productList,
    required this.warehouseDestiny,
    required this.warehouseList,
    required this.concept,
  });

  ReportInventoryMoveModel.empty()
      : concept = ConceptMoveModel.empty(),
        dateTime = DateTime(0),
        document = '',
        productList = [],
        warehouse = WarehouseModel.empty(),
        warehouseDestiny = WarehouseModel.empty(),
        warehouseList = [];

  ReportInventoryMoveModel.transfer({
    required this.warehouse,
    required this.warehouseDestiny,
    required this.dateTime,
    required this.document,
    required this.productList,
  })  : warehouseList = [],
        concept = ConceptMoveModel.empty();

  ReportInventoryMoveModel.singleMove({
    required this.warehouse,
    required this.dateTime,
    required this.document,
    required this.productList,
    required this.concept,
  })  : warehouseDestiny = WarehouseModel.empty(),
        warehouseList = [];

  static List<ReportInventoryRowModel> movesToReportRows(
      List<InventoryMoveRowModel> moveList) {
    List<ReportInventoryRowModel> reportRowList = [];
    ReportInventoryRowModel reportRow;

    for (var move in moveList) {
      reportRow = ReportInventoryRowModel(
        product: move.product,
        quantity: double.tryParse(move.quantityTf.text) ?? 0,
      );
      reportRowList.add(reportRow);
    }

    return reportRowList;
  }
}
