class VendorModel {
  final int id;
  final String name;

  static const String _id = 'id';
  static const String _name = 'name';

  String get tId => _id;
  String get tName => _name;

  VendorModel({
    required this.id,
    required this.name,
  });

  VendorModel.empty()
      : id = -1,
        name = '';

  static VendorModel fillMap(Map<String, dynamic> map) {
    VendorModel vendorModel;
    if (map.keys.contains(_id) && map.keys.contains(_name)) {
      vendorModel = VendorModel(id: map[_id], name: map[_name]);
    } else {
      vendorModel = VendorModel.empty();
    }
    return vendorModel;
  }
}
