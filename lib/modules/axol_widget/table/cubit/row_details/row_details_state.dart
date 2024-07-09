import 'package:equatable/equatable.dart';

abstract class RowDetailsState extends Equatable {
  const RowDetailsState();
}

class InitialRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadingRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadedRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

class ErrorRowDetailsState extends RowDetailsState {
  final String error;
  const ErrorRowDetailsState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}