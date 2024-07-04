import 'package:flutter/widgets.dart';

import 'block_model.dart';
import 'property_model.dart';

/// Modelo de datos que contiene las propiedades 
/// del bloque y varían según el cambio de estado.
class SetBlockFormModel {
  List<BlockModel> blockList;
  BlockModel? cBlock;
  int select;
  TextEditingController ctrlBlockName;
  List<SetBlockPropModel> properties;
  double heightBoxProp;
  bool isChanged;
  int theme;

  SetBlockFormModel({
    required this.blockList,
    required this.select,
    required this.ctrlBlockName,
    required this.properties,
    this.cBlock,
    required this.heightBoxProp,
    required this.isChanged,
    required this.theme,
  });

  SetBlockFormModel.empty()
      : blockList = [],
        select = -1,
        ctrlBlockName = TextEditingController(),
        properties = [],
        heightBoxProp = 0,
        isChanged = false,
        theme = 0;
}

class SetBlockPropModel {
  TextEditingController ctrlProp;
  Prop property;
  String key;

  SetBlockPropModel({
    required this.ctrlProp,
    required this.property,
    required this.key
  });

  SetBlockPropModel.empty()
      : ctrlProp = TextEditingController(),
        property = Prop.text,
        key = '';

  static List<SetBlockPropModel> propListToForm(
      List<PropertyModel> properties) {
    List<SetBlockPropModel> propList = [];
    SetBlockPropModel prop;

    for (var element in properties) {
      prop = SetBlockPropModel(
        ctrlProp: TextEditingController(text: element.name),
        property: element.propertyType,
        key: element.key,
      );
      propList.add(prop);
    }

    return propList;
  }
}
