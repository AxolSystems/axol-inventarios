import 'package:equatable/equatable.dart';

abstract class WbListState extends Equatable {
  const WbListState();
}

class InitialWbListState extends WbListState {
  @override
  List<Object?> get props => [];
}

class LoadingWbListState extends WbListState {
  @override
  List<Object?> get props => [];
}

class LoadedWbListState extends WbListState {
  @override
  List<Object?> get props => [];
}

class ErrorWbListState extends WbListState {
  final String error;
  const ErrorWbListState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}