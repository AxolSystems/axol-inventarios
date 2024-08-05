import 'package:equatable/equatable.dart';

/// Estados de cubit para drawer de detalles de objetos.
abstract class SearchRefObjState extends Equatable {
  const SearchRefObjState();
}

/// Estado inicial del cubit.
class InitialSearchRefObjState extends SearchRefObjState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera cuando se desarrolla un proceso.
class LoadingSearchRefObjState extends SearchRefObjState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finaliza el estado de carga y muestra 
/// los resultados obtenidos de los procesos anteriores.
class LoadedSearchRefObjState extends SearchRefObjState {
  @override
  List<Object?> get props => [];
}

/// Estado de error que aparece cuando se llega aun conflicto.
class ErrorSearchRefObjState extends SearchRefObjState {
  final String error;
  const ErrorSearchRefObjState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}