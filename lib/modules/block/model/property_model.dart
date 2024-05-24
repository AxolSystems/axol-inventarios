enum Prop {text, int, double, time, bool}

class PropertyModel {
  final String name;
  final Prop propertyType;

  PropertyModel({required this.name, required this.propertyType});

  PropertyModel.empty() : 
  name = '',
  propertyType = Prop.text;

  static List<PropertyModel> mapToProperty(Map<String,dynamic> map) {
    List<PropertyModel> propertyList = [];
    
    return propertyList;
  }

}