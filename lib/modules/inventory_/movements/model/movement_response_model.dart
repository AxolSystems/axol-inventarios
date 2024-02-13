import 'movement_model.dart';

class MovementResponseModel {
  final List<MovementModel> movementList;
  final  int count;

  MovementResponseModel({required this.movementList, required this.count});
}