/// Modelo de datos de un objeto. Los objetos en Axol 
/// son las filas almacenadas en los bloques de la base 
/// de datos. Cada una de estas filas u objetos, representan 
/// una entidad externa creada por el usuario.
/// 
/// __Estructura de map__: map => {nombre de columna: dato}
class ObjectModel {
  final String id;
  final Map<String, dynamic> map;
  final DateTime createAt;

  ObjectModel({
    required this.id,
    required this.map,
    required this.createAt,
  });
}
