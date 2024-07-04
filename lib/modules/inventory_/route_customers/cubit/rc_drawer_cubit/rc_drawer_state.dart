import 'package:equatable/equatable.dart';

abstract class RcDrawerState extends Equatable {
  const RcDrawerState();
}

class InitialState extends RcDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends RcDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends RcDrawerState {
  final List<String> response;
  const LoadedState({required this.response});
  @override
  List<Object?> get props => [response];
}

class ErrorState extends RcDrawerState {
  final String error;
  const ErrorState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}