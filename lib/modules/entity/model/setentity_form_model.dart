import 'package:flutter/widgets.dart';

import 'entity_model.dart';
import 'property_model.dart';

/// Modelo de datos que contiene las propiedades 
/// del bloque y varían según el cambio de estado.
class SetEntityFormModel {
  List<EntityModel> entityList;
  EntityModel? cEntity;
  int select;
  TextEditingController ctrlEntityName;
  List<SetEntityPropModel> properties;
  double heightBoxProp;
  bool isChanged;
  int theme;

  SetEntityFormModel({
    required this.entityList,
    required this.select,
    required this.ctrlEntityName,
    required this.properties,
    this.cEntity,
    required this.heightBoxProp,
    required this.isChanged,
    required this.theme,
  });

  SetEntityFormModel.empty()
      : entityList = [],
        select = -1,
        ctrlEntityName = TextEditingController(),
        properties = [],
        heightBoxProp = 0,
        isChanged = false,
        theme = 0;
}

class SetEntityPropModel {
  TextEditingController ctrlProp;
  Prop property;
  String key;

  SetEntityPropModel({
    required this.ctrlProp,
    required this.property,
    required this.key
  });

  SetEntityPropModel.empty()
      : ctrlProp = TextEditingController(),
        property = Prop.text,
        key = '';

  static List<SetEntityPropModel> propListToForm(
      List<PropertyModel> properties) {
    List<SetEntityPropModel> propList = [];
    SetEntityPropModel prop;

    for (var element in properties) {
      prop = SetEntityPropModel(
        ctrlProp: TextEditingController(text: element.name),
        property: element.propertyType,
        key: element.key,
      );
      propList.add(prop);
    }

    return propList;
  }
}
