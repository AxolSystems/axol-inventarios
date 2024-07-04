class RoutcustomerModel {
  final int id;
  final String name;
  final String location;
  final String vendor;
  final Map<String, dynamic> address;
  final Map<String, dynamic> validation;

  const RoutcustomerModel(
      {required this.id,
      required this.name,
      required this.location,
      required this.address,
      required this.validation,
      required this.vendor});

  static const String pId = 'id';
  static const String pName = 'name';
  static const String pLocation = 'location';
  static const String pVendor = 'vendor';
  //-----Address-----
  static const String pAddress = 'address';
  static const String pHood = 'hood';
  static const String pTown = 'town';
  static const String pCountry = 'country';
  //-----Validation-----
  static const String pStatus = 'status';
  static const String pAdminUser = 'user';
}
