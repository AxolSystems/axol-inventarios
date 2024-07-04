import 'package:equatable/equatable.dart';

abstract class SetModuleDrawerState extends Equatable {
  const SetModuleDrawerState();
}

class InitialSetModuleDrawerState extends SetModuleDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadingSetModuleDrawerState extends SetModuleDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadedSetModuleDrawerState extends SetModuleDrawerState {
  @override
  List<Object?> get props => [];
}

class SavingSetModuleDrawerState extends SetModuleDrawerState {
  @override
  List<Object?> get props => [];
}

class SavedSetModuleDrawerState extends SetModuleDrawerState {
  @override
  List<Object?> get props => [];
}

class ErrorSetModuleDrawerState extends SetModuleDrawerState {
  final String error;
  const ErrorSetModuleDrawerState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}

enum SetModuleStateEnum { loading, saving, loaded }
