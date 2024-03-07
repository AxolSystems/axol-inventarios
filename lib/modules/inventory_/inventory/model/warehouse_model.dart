class WarehouseModel {
  final int id;
  final String name;
  final String retailManager;

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
        retailManager = '';

  static WarehouseModel empty() =>
      const WarehouseModel(id: -1, name: '', retailManager: '');

  static WarehouseModel fillMap(Map<String, dynamic> map) {
    WarehouseModel warehouseModel;
    if (map.containsKey(id_) &&
        map.containsKey(name_) &&
        map.containsKey(manager_)) {
      warehouseModel = WarehouseModel(
          id: map[id_], name: map[name_], retailManager: map[manager_]);
    } else {
      warehouseModel = WarehouseModel.empty();
    }
    return warehouseModel;
  }
}
