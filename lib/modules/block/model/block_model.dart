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
}
