class ObjectModel {
  final String id;
  //map => {nombre de columna: dato}
  final Map<String, dynamic> map;
  final DateTime createAt;

  ObjectModel({
    required this.id,
    required this.map,
    required this.createAt,
  });
}
