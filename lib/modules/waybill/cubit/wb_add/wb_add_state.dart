import 'package:equatable/equatable.dart';

abstract class WbAddState extends Equatable {
  const WbAddState();
}

class InitialWbAddState extends WbAddState {
  @override
  List<Object?> get props => [];
}

class LoadingWbAddState extends WbAddState {
  @override
  List<Object?> get props => [];
}

class LoadedWbAddState extends WbAddState {
  @override
  List<Object?> get props => [];
}

enum SavedWbAdd {add, edit}

class SavedWbAddState extends WbAddState {
  @override
  List<Object?> get props => [];
}

class ErrorWbAddState extends WbAddState {
  final String error;
  const ErrorWbAddState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}