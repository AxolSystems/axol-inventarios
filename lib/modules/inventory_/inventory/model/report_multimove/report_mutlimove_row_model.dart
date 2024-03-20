import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';

import '../../../product/model/product_model.dart';
import 'report_multimove_subrow_model.dart';

class ReportMultimoveRowModel {
  final ProductModel product;
  final WarehouseModel warehouse;
  final List<ReportMultimoveSubrowModel> subrowList;

  const ReportMultimoveRowModel({
    required this.product,
    required this.warehouse,
    required this.subrowList,
  });

  ReportMultimoveRowModel.empty()
      : product = ProductModel.empty(),
        warehouse = WarehouseModel.empty(),
        subrowList = [];

  static ReportMultimoveRowModel addSubrow({
    required ReportMultimoveRowModel row,
    required ReportMultimoveSubrowModel subrow,
  }) {
    ReportMultimoveRowModel upRow;
    List<ReportMultimoveSubrowModel> subrowList;

    subrowList = row.subrowList;
    subrowList.add(subrow);

    upRow = ReportMultimoveRowModel(
      product: row.product,
      warehouse: row.warehouse,
      subrowList: subrowList,
    );
    return upRow;
  }
}
