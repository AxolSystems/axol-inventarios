import 'package:axol_inventarios/modules/object/model/object_model.dart';

import '../../entity/model/property_model.dart';
import '../../widget_link/model/widgetlink_model.dart';

class AtomicObjectModel {
  final String id;
  final Map<String, dynamic> values;
  final String? referenceLinkId;
  final String? referenceObjectId;

  AtomicObjectModel({
    required this.id,
    required this.values,
    this.referenceLinkId,
    this.referenceObjectId,
  });

  AtomicObjectModel.empty()
      : id = '',
        values = {},
        referenceLinkId = '',
        referenceObjectId = '';

  AtomicObjectModel.idInit(this.id)
      : values = {},
        referenceLinkId = '',
        referenceObjectId = '';

  /// get 'prop_value'
  static String get tValue => 'value';

  /// get 'properties'
  static String get tProperties => 'properties';

  /// get 'object'
  static String get tObject => 'object';

  /// get 'id'
  static String get tId => 'id';

  static AtomicObjectModel mapToAtomObj(Map<String, dynamic>? map,
      [ObjectModel? objectRef, WidgetLinkModel? linkRef]) {
    AtomicObjectModel atomicObject;
    String id = '';
    Map<String, dynamic> values = {};
    String? referenceLinkId = linkRef?.id;
    String? referenceObjectId = objectRef?.id;

    if (map != null && map.isNotEmpty) {
      if (map.containsKey(tId)) {
        id = map[tId];
      }
      if (map.containsKey(tObject)) {
        for (String key in map[tObject].keys) {
          values[key] = map[tObject][key];
        }
      }
    }

    atomicObject = AtomicObjectModel(
      id: id,
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
