import 'property_model.dart';

/// Los bloques son tablas genéricas en las bases de datos que 
/// se usan para almacenar los objetos. Solo almacena un tipo 
/// de objeto, razón por la que sus propiedades serán las mismas 
/// que las de los objetos que contiene. 
class BlockModel {
  final String uuid;
  final String tableName;
  final String blockName;
  final List<PropertyModel> propertyList;

  BlockModel(
      {required this.blockName,
      required this.propertyList,
      required this.tableName,
      required this.uuid});

  /// Devuelve el estado inicial del bloque.
  BlockModel.empty()
      : uuid = '',
        tableName = '',
        blockName = '',
        propertyList = [];

  /// Devuelve el mismo bloque que recibe, pero con el nombre 
  /// del parámetro.
  BlockModel.setName(BlockModel block, this.blockName)
      : uuid = block.uuid,
        tableName = block.tableName,
        propertyList = block.propertyList;

  /// Convierte una lista de propiedades a map. 
  /// 
  /// Esté método se puede utilizar para realizar la conversión 
  /// al tipo de dato que se necesita para guardar las propiedades 
  /// del bloque en la base de datos.
  static Map<String, dynamic> propsToMap(List<PropertyModel> props) {
    Map<String, dynamic> map = {};
    if (props.isNotEmpty) {
      for (PropertyModel prop in props) {
        map[prop.name] =
            '${prop.name}~${PropertyModel.getIntToProp(prop.propertyType)}';
      }
    }
    return map;
  }
}
