import 'package:equatable/equatable.dart';

abstract class SetBlockState extends Equatable {
  const SetBlockState();
}

class InitialSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

class LoadingSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

class LoadedSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

class SavingSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

class SavedSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

class ErrorSetBlockState extends SetBlockState {
  final String error;
  const ErrorSetBlockState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}