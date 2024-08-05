import 'package:equatable/equatable.dart';

abstract class FilterPropState extends Equatable {
  const FilterPropState();
}

/// Estado inicial del cubit.
class InitialFilterPropState extends FilterPropState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera cuando se desarrolla un proceso.
class LoadingFilterPropState extends FilterPropState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finaliza el estado de carga y muestra 
/// los resultados obtenidos de los procesos anteriores.
class LoadedFilterPropState extends FilterPropState {
  @override
  List<Object?> get props => [];
}

/// Estado de error que aparece cuando se llega aun conflicto.
class ErrorFilterPropState extends FilterPropState {
  final String error;
  const ErrorFilterPropState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}