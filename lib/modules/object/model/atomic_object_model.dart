import 'package:axol_inventarios/modules/object/model/object_model.dart';

import '../../entity/model/property_model.dart';
import '../../widget_link/model/widgetlink_model.dart';

class AtomicObjectModel {
  final List<PropertyModel> properties;
  final Map<String, dynamic> values;
  final String? referenceLinkId;
  final String? referenceObjectId;

  AtomicObjectModel({
    required this.properties,
    required this.values,
    this.referenceLinkId,
    this.referenceObjectId,
  });

  AtomicObjectModel.empty()
      : properties = [],
        values = {},
        referenceLinkId = '',
        referenceObjectId = '';

  /// get 'prop_value'
  static String get tValue => 'value';
  /// get 'properties'
  static String get tProperties => 'properties';
  /// get 'object'
  static String get tObject => 'object';

  static AtomicObjectModel mapToAtomObj(Map<String, dynamic>? map,
      [ObjectModel? objectRef, WidgetLinkModel? linkRef]) {
    AtomicObjectModel atomicObject;
    Map<String, dynamic> values = {};
    List<PropertyModel> propertyList = [];
    String? referenceLinkId = linkRef?.id;
    String? referenceObjectId = objectRef?.id;

    if (map != null && map.isNotEmpty) {
      if (map.containsKey(tProperties) &&
          map[tProperties][PropertyModel.dataType] == 7) {
        if (objectRef != null && linkRef != null) {
          values = objectRef.map;
          for (PropertyModel property in linkRef.entity.propertyList) {
            propertyList.add(property);
          }
        } else if (map[tProperties][PropertyModel.tDynamicValues]
            .containsKey(PropertyModel.dvPropsAtomObj)) {
          for (String key in map[tObject].keys) {
            if (map[tProperties][PropertyModel.tDynamicValues]
                    [PropertyModel.dvPropsAtomObj]
                .containsKey[key]) {
              values[key] = map[tObject][key];
            }
          }
          for (String key in map[tProperties][PropertyModel.tDynamicValues]
                  [PropertyModel.dvPropsAtomObj]
              .keys) {
            final Map<String, dynamic> mapProp = map[tProperties]
                    [PropertyModel.tDynamicValues][PropertyModel.dvPropsAtomObj]
                [key];
            propertyList.add(PropertyModel(
                name: mapProp[PropertyModel.propName],
                propertyType: mapProp[PropertyModel.dataType],
                key: key,
                dynamicValues: mapProp[PropertyModel.tDynamicValues]));
          }
        }
      }
    }

    atomicObject = AtomicObjectModel(
      properties: propertyList,
      values: values,
      referenceLinkId: referenceLinkId,
      referenceObjectId: referenceObjectId,
    );

    return atomicObject;
  }

  /// Valida si el objeto atómico en la base de datos está referenciado a un
  /// objeto externo.
  static bool isObjAtmRef(Map<String, dynamic>? map) {
    bool isExternal = false;
    if (map != null && map.isNotEmpty) {
      if (map[tProperties][PropertyModel.tDynamicValues]
          .containsKey(PropertyModel.dvExternalRef)) {
        isExternal = true;
      }
    }
    return isExternal;
  }
}
