import 'package:equatable/equatable.dart';

abstract class SetModuleState extends Equatable {
  const SetModuleState();
}

class InitialSetModuleState extends SetModuleState {
  @override
  List<Object?> get props => [];
}

class LoadingSetModuleState extends SetModuleState {
  @override
  List<Object?> get props => [];
}

class LoadedSetModuleState extends SetModuleState {
  @override
  List<Object?> get props => [];
}

class ErrorSetModuleState extends SetModuleState {
  final String error;
  const ErrorSetModuleState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}