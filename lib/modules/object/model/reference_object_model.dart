import '../../entity/model/property_model.dart';
import 'object_model.dart';

class ReferenceObjectModel {
  final String idEntity;
  final String idPropertyView;
  final ObjectModel referenceObject;
  final List<PropertyModel> propertyList;

  ReferenceObjectModel({
    required this.idEntity,
    required this.referenceObject,
    required this.propertyList,
    required this.idPropertyView,
  });

  ReferenceObjectModel.empty()
      : idEntity = '',
        referenceObject = ObjectModel.empty(),
        propertyList = [],
        idPropertyView = '';

  ReferenceObjectModel.setPropView(
      ReferenceObjectModel refObj, this.idPropertyView)
      : idEntity = refObj.idEntity,
        referenceObject = refObj.referenceObject,
        propertyList = refObj.propertyList;

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

  PropertyModel getPropView() => propertyList.firstWhere(
        (x) => x.key == idPropertyView,
        orElse: () => PropertyModel.empty(),
      );
}
