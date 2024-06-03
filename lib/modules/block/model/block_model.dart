import 'property_model.dart';

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

  BlockModel.setName(BlockModel block, this.blockName)
      : uuid = block.uuid,
        tableName = block.tableName,
        propertyList = block.propertyList;

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
