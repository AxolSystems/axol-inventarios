class WarehouseModel {
  final int id;
  final String name;
  final int retailManager;

  static const String id_ = 'id';
  static const String name_ = 'name';
  static const String manager_ = 'retail_manager';

  String get tId => id_;
  String get tName => name_;
  String get tManager => manager_;

  const WarehouseModel({
    required this.id,
    required this.name,
    required this.retailManager,
  });

  WarehouseModel.multi()
      : id = -2,
        name = 'Multialmacén',
        retailManager = -2;

  static WarehouseModel empty() =>
      const WarehouseModel(id: -1, name: '', retailManager: -1);

  static WarehouseModel fillMap(Map<String, dynamic> map) {
    WarehouseModel warehouseModel;
    if (map.containsKey(id_) &&
        map.containsKey(name_) &&
        map.containsKey(manager_)) {
      warehouseModel = WarehouseModel(
          id: map[id_], name: map[name_], retailManager: int.tryParse(map[manager_].toString()) ?? -1);
    } else {
      warehouseModel = WarehouseModel.empty();
    }
    return warehouseModel;
  }
}
