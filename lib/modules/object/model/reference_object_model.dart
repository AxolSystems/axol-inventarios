import '../../entity/model/property_model.dart';
import 'object_model.dart';

class ReferenceObjectModel {
  final String idEntity;
  final ObjectModel referenceObject;
  final List<PropertyModel> propertyList;

  ReferenceObjectModel({
    required this.idEntity,
    required this.referenceObject,
    required this.propertyList,
  });

  ReferenceObjectModel.empty()
      : idEntity = '',
        referenceObject = ObjectModel.empty(),
        propertyList = [];

  /// get: 'id_entity'
  static String get entity => 'id_entity';

  /// get: 'id_object'
  static String get object => 'id_object';

  /// get: 'id_property'
  static String get property => 'id_property';

  /// get: 'reference_object'
  static String get refObj => 'reference_object';

  /// get: 'object_property'
  static String get objProp => 'object_property';
}
