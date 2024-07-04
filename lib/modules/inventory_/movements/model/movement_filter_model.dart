import '../../inventory/model/warehouse_model.dart';

enum MovementFilterTag {
  warehouse,
  intDate,
  endDate,
  filterDate,
  document,
  folio,
  concept,
}

class MovementFilterModel {
  final WarehouseModel warehouse;
  final DateTime initDate;
  final DateTime endDate;
  final bool filterDate;
  final List<String> document;
  final List<int> folio;
  final List<int> concept;

  static Map get initMap => {
        MovementFilterTag.endDate: MovementFilterModel.empty().endDate,
        MovementFilterTag.filterDate: MovementFilterModel.empty().filterDate,
        MovementFilterTag.intDate: MovementFilterModel.empty().initDate,
        MovementFilterTag.warehouse: MovementFilterModel.empty().warehouse,
      };

  const MovementFilterModel({
    required this.initDate,
    required this.endDate,
    required this.warehouse,
    required this.filterDate,
    required this.document,
    required this.folio,
    required this.concept,
  });

  MovementFilterModel.empty()
      : initDate = DateTime.now(),
        endDate = DateTime.now(),
        warehouse = WarehouseModel.empty(),
        filterDate = false,
        document = [],
        folio = [],
        concept = [];

  static MovementFilterModel mapToFilter(Map map) {
    final MovementFilterModel filter;
    WarehouseModel warehouse = MovementFilterModel.empty().warehouse;
    DateTime initDate = MovementFilterModel.empty().initDate;
    DateTime endDate = MovementFilterModel.empty().endDate;
    bool filterDate = MovementFilterModel.empty().filterDate;
    List<String> document = MovementFilterModel.empty().document;
    List<int> folio = MovementFilterModel.empty().folio;
    List<int> concept = MovementFilterModel.empty().concept;

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
      if (key == MovementFilterTag.document && map[key] is List<String>) {
        document = map[key];
      }
      if (key == MovementFilterTag.folio && map[key] is List<int>) {
        folio = map[key];
      }
      if (key == MovementFilterTag.concept && map[key] is List<int>) {
        concept = map[key];
      }
    }

    filter = MovementFilterModel(
      initDate: initDate,
      endDate: endDate,
      warehouse: warehouse,
      filterDate: filterDate,
      document: document,
      folio: folio,
      concept: concept,
    );
    return filter;
  }

  static Map filterToMap(MovementFilterModel filter) {
    final Map map = {
      MovementFilterTag.intDate: filter.initDate,
      MovementFilterTag.endDate: filter.endDate,
      MovementFilterTag.filterDate: filter.filterDate,
      MovementFilterTag.warehouse: filter.warehouse,
      MovementFilterTag.document: filter.document,
      MovementFilterTag.folio: filter.folio,
      MovementFilterTag.concept: filter.concept,
    };
    return map;
  }
}
