import 'package:equatable/equatable.dart';

abstract class TableState extends Equatable {
  const TableState();
}

class InitialTableState extends TableState {
  @override
  List<Object?> get props => [];
}

class LoadingTableState extends TableState {
  @override
  List<Object?> get props => [];
}

class LoadedTableState extends TableState {
  @override
  List<Object?> get props => [];
}

class ErrorTableState extends TableState {
  final String error;
  const ErrorTableState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}