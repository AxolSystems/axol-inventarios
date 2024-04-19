import 'package:equatable/equatable.dart';

enum SrpAddSubState {add, edit}

abstract class SrpAddState extends Equatable {
  const SrpAddState();
}

class InitialSrpAddState extends SrpAddState {
  @override
  List<Object?> get props => [];
}

class LoadingSrpAddState extends SrpAddState {
  @override
  List<Object?> get props => [];
}

class LoadedSrpAddState extends SrpAddState {
  @override
  List<Object?> get props => [];
}

class SavedSrpAddState extends SrpAddState {
  @override
  List<Object?> get props => [];
}

class ErrorSrpAddState extends SrpAddState {
  final String error;
  const ErrorSrpAddState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}