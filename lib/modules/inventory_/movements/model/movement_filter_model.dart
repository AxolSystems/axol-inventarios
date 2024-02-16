import '../../inventory/model/warehouse_model.dart';

enum MovementFilterTag { warehouse, intDate, endDate, filterDate}

class MovementFilterModel {
  final WarehouseModel warehouse;
  final DateTime initDate;
  final DateTime endDate;
  final bool filterDate;

  const MovementFilterModel({
    required this.initDate,
    required this.endDate,
    required this.warehouse,
    required this.filterDate,
  });

  MovementFilterModel.empty()
      : initDate = DateTime(0),
        endDate = DateTime(3000),
        warehouse = WarehouseModel.empty(),
        filterDate = false;

  static MovementFilterModel mapToFilter(Map map) {
    final MovementFilterModel filter;
    WarehouseModel warehouse = MovementFilterModel.empty().warehouse;
    DateTime initDate = MovementFilterModel.empty().initDate;
    DateTime endDate = MovementFilterModel.empty().endDate;
    bool filterDate = MovementFilterModel.empty().filterDate;

    for (var key in map.keys) {
      if (key == MovementFilterTag.warehouse && map[key] is WarehouseModel) {
        warehouse = map[key];
      }
      if (key == MovementFilterTag.endDate && map[key] is DateTime) {
        endDate = map[key];
      }
      if (key == MovementFilterTag.intDate && map[key] is DateTime) {
        initDate = map[key];
      }
      if (key == MovementFilterTag.filterDate && map[key] is bool) {
        filterDate = map[key];
      }
    }

    filter = MovementFilterModel(
      initDate: initDate,
      endDate: endDate,
      warehouse: warehouse,
      filterDate: filterDate,
    );
    return filter;
  }
}
