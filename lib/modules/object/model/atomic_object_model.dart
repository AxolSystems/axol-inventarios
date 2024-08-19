import '../../entity/model/property_model.dart';

class AtomicObjectModel {
  final String id;
  final String propertyName;
  final Prop propertyType;
  final dynamic value;

  AtomicObjectModel({
    required this.id,
    required this.propertyName,
    required this.propertyType,
    required this.value,
  });

  AtomicObjectModel.empty()
      : id = '',
        propertyName = '',
        propertyType = Prop.empty,
        value = null;

  /// get 'prop_name'
  static String get tPropName => 'prop_name';

  /// get 'prop_type'
  static String get tPropType => 'prop_type';

  /// get 'prop_value'
  static String get tValue => 'value';

  static List<AtomicObjectModel> mapToAtomObjs(Map<String, Map<String, dynamic>> map) {
    List<AtomicObjectModel> atomicObjectList = [];
    for (String key in map.keys) {
      atomicObjectList.add(AtomicObjectModel(
        id: key,
        propertyName: map[key]![tPropName],
        propertyType: map[key]![tPropType],
        value: map[key]![tValue],
      ));
    }
    return atomicObjectList;
  }
}
