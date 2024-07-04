import 'package:equatable/equatable.dart';

abstract class RcDetailsState extends Equatable {
  const RcDetailsState();
}

class InitialState extends RcDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends RcDetailsState {
  final bool isValid;
  const LoadingState({required this.isValid});
  @override
  List<Object?> get props => [isValid];
}

class LoadedState extends RcDetailsState {
  final bool isValid;
  const LoadedState({required this.isValid});
  @override
  List<Object?> get props => [isValid];
}

class ErrorState extends RcDetailsState {
  final String error;
  const ErrorState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}