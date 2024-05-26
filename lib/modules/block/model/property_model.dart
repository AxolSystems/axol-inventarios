enum Prop { text, int, double, time, bool }

class PropertyModel {
  final String name;
  final Prop propertyType;

  PropertyModel({required this.name, required this.propertyType});

  PropertyModel.empty()
      : name = '',
        propertyType = Prop.text;

  static List<PropertyModel> mapToProperty(Map<String, dynamic> map) {
    List<PropertyModel> propertyList = [];
    PropertyModel property;
    List<dynamic> values;

    values = map.values.toList();
    for (var value in values) {
      if (value is String) {
        property = PropertyModel(
          name: value.split('~').first,
          propertyType: getPropToInt(int.tryParse(value.split('~').last) ?? 0),
        );
        propertyList.add(property);
      }
    }

    return propertyList;
  }

  static Prop getPropToInt(int n) {
    switch (n) {
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
        return Prop.text;
    }
  }

  static int getIntToProp(Prop prop) {
    switch (prop) {
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
        return 0;
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
