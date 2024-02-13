import 'package:equatable/equatable.dart';

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
  @override
  List<Object?> get props => [];
}

class ErrorMovementTabState extends MovementTabState {
  final String error;
  const ErrorMovementTabState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}