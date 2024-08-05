import '../../../utilities/format.dart';
import '../../entity/model/property_model.dart';
import 'object_model.dart';

class ReferenceObjectModel {
  final String idLink;
  final String idPropertyView;
  final ObjectModel referenceObject;
  final List<PropertyModel> propertyList;

  ReferenceObjectModel({
    required this.idLink,
    required this.referenceObject,
    required this.propertyList,
    required this.idPropertyView,
  });

  ReferenceObjectModel.empty()
      : idLink = '',
        referenceObject = ObjectModel.empty(),
        propertyList = [],
        idPropertyView = '';

  ReferenceObjectModel.setPropView(
      ReferenceObjectModel refObj, this.idPropertyView)
      : idLink = refObj.idLink,
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

  String getPropViewText() {
    final String text;
    final PropertyModel property;

    property = getPropView();

    if (property.propertyType == Prop.text) {
      text = referenceObject.map[property.key] ?? '';
    } else if (property.propertyType == Prop.int ||
        property.propertyType == Prop.double) {
      text = '${referenceObject.map[property.key] ?? ''}';
    } else if (property.propertyType == Prop.time) {
      text = FormatDate.dmyHm(DateTime.fromMillisecondsSinceEpoch(
          referenceObject.map[property.key] ?? 0));
    } else if (property.propertyType == Prop.bool) {
      text = '${referenceObject.map[property.key] ?? ''}';
    } else {
      text = '';
    }

    return text;
  }
}
