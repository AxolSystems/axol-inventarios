import 'package:equatable/equatable.dart';

import '../../model/movement_filter_model.dart';

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

class SavedMovementFilterState extends MovementFilterState {
  final MovementFilterModel filter;
  const SavedMovementFilterState({required this.filter});
  @override
  List<Object?> get props => [filter];
}

class ErrorMovementFilterState extends MovementFilterState {
  final String error;
  const ErrorMovementFilterState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
