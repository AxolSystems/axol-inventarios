enum Prop {text, int, double, time, bool}

class PropertyModel {
  final String name;
  final Prop propertyType;

  PropertyModel({required this.name, required this.propertyType});

}