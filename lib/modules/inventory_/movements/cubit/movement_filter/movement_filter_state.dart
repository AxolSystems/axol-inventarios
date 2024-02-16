import 'package:equatable/equatable.dart';

abstract class MovementFilterState extends Equatable {
  const MovementFilterState();
}

class InitialMovementFilterState extends MovementFilterState {
  @override
  List<Object?> get props => [];
}

class LoadingMovementFilterState extends MovementFilterState {
  @override
  List<Object?> get props => [];
}

class LoadedMovementFilterState extends MovementFilterState {
  @override
  List<Object?> get props => [];
}

class ErrorMovementFilterState extends MovementFilterState {
  final String error;
  const ErrorMovementFilterState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
