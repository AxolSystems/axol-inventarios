import 'package:equatable/equatable.dart';

abstract class FilterState extends Equatable {
  const FilterState();
}

class InitialFilterState extends FilterState {
  @override
  List<Object?> get props => [];
}

class LoadingFilterState extends FilterState {
  @override
  List<Object?> get props => [];
}

class LoadedFilterState extends FilterState {
  @override
  List<Object?> get props => [];
}

class ErrorFilterState extends FilterState {
  final String error;
  const ErrorFilterState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}