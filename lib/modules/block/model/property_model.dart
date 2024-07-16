enum Prop { text, int, double, time, bool, empty }

class PropertyModel {
  final String name;
  final Prop propertyType;
  final String key;

  PropertyModel(
      {required this.name, required this.propertyType, required this.key});

  PropertyModel.empty()
      : name = '',
        propertyType = Prop.empty,
        key = '';

  static String get dataType => 'dataType';
  static String get propName => 'propName';

  static List<PropertyModel> mapToProperty(Map<String, dynamic> map) {
    List<PropertyModel> propertyList = [];
    PropertyModel property;

    for (var key in map.keys.toList()) {
      final Map<String, dynamic> value = map[key];
      property = PropertyModel(
          name: value[PropertyModel.propName],
          propertyType:
              PropertyModel.getPropToInt(value[PropertyModel.dataType]),
          key: key);
      propertyList.add(property);
    }

    return propertyList;
  }

  static Prop getPropToInt(int n) {
    switch (n) {
      case -1:
        return Prop.empty;
      case 0:
        return Prop.text;
      case 1:
        return Prop.int;
      case 2:
        return Prop.double;
      case 3:
        return Prop.time;
      case 4:
        return Prop.bool;
      default:
        return Prop.empty;
    }
  }

  static int getIntToProp(Prop prop) {
    switch (prop) {
      case Prop.empty:
        return -1;
      case Prop.text:
        return 0;
      case Prop.int:
        return 1;
      case Prop.double:
        return 2;
      case Prop.time:
        return 3;
      case Prop.bool:
        return 4;
      default:
        return -1;
    }
  }

  static String getTextToProp(Prop prop) {
    switch (prop) {
      case Prop.text:
        return 'Texto';
      case Prop.int:
        return 'Número entero';
      case Prop.double:
        return 'Número decimal';
      case Prop.time:
        return 'Fecha';
      case Prop.bool:
        return 'Booleano';
      default:
        return 'Texto';
    }
  }
}
