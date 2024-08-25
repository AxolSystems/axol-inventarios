import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';

import '../../../utilities/format.dart';

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

  ObjectModel.empty() : 
  id = '',
  map = {},
  createAt = DateTime(0);

  static ObjectModel setId(ObjectModel object, String id_) => ObjectModel(id: id_, map: object.map, createAt: object.createAt);

  String dataViewText(PropertyModel property) {
    String text;

    if (property.propertyType == Prop.text) {
      text = map[property.key] ?? '';
    } else if (property.propertyType == Prop.int ||
        property.propertyType == Prop.double) {
      text = '${map[property.key] ?? ''}';
    } else if (property.propertyType == Prop.time) {
      text = FormatDate.dmyHm(DateTime.fromMillisecondsSinceEpoch(
          map[property.key] ?? 0));
    } else if (property.propertyType == Prop.bool) {
      text = '${map[property.key] ?? ''}';
    } else if (property.propertyType == Prop.referenceObject) {
      final ReferenceObjectModel referenceObject = map[property.key];
      text = referenceObject.getPropViewText();
    } else {
      text = '';
    }

    return text;
  }
}
