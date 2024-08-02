import '../../entity/model/property_model.dart';

class ReferenceObjectModel {
  final String idEntity;
  final String idObject;
  final String? idProperty;
  final dynamic data;
  final Prop? prop;

  ReferenceObjectModel({
    required this.idEntity,
    required this.idObject,
    required this.idProperty,
    required this.data,
    required this.prop,
  });

  static String get entity => 'id_entity';
  static String get object => 'id_object';
  static String get property => 'id_property'; 
}
