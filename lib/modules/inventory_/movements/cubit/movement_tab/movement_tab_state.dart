import 'package:equatable/equatable.dart';

import '../../model/movement_model.dart';

abstract class MovementTabState extends Equatable {
  const MovementTabState();
}

class InitialMovementTabState extends MovementTabState {
  @override
  List<Object?> get props => [];
}

class LoadingMovementTabState extends MovementTabState {
  @override
  List<Object?> get props => [];
}

class LoadedMovementTabState extends MovementTabState {
  final List<MovementModel> movementList;
  const LoadedMovementTabState({required this.movementList});
  @override
  List<Object?> get props => [movementList];
}

class ErrorMovementTabState extends MovementTabState {
  final String error;
  const ErrorMovementTabState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}