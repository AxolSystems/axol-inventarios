import 'package:equatable/equatable.dart';

/// Estados de cubit para drawer de detalles de objetos.
abstract class ObjectDetailsState extends Equatable {
  const ObjectDetailsState();
}

/// Estado inicial del cubit.
class InitialObjectDetailsState extends ObjectDetailsState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera cuando se desarrolla un proceso.
class LoadingObjectDetailsState extends ObjectDetailsState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finaliza el estado de carga y muestra 
/// los resultados obtenidos de los procesos anteriores.
class LoadedObjectDetailsState extends ObjectDetailsState {
  @override
  List<Object?> get props => [];
}

/// Estado de al que pasa una vez finalizado el proceso de guardado.
class SavedObjectDetailsState extends ObjectDetailsState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera cuando se encuentra en el estado de guardado.
class SavingObjectDetailsState extends ObjectDetailsState {
  @override
  List<Object?> get props => [];
}

class DeletingObjectDetailsState extends ObjectDetailsState {
  @override
  List<Object?> get props => [];
}

class DeletedObjectDetailsState extends ObjectDetailsState {
  @override
  List<Object?> get props => [];
}


/// Estado de error que aparece cuando se llega aun conflicto.
class ErrorRowDetailsState extends ObjectDetailsState {
  final String error;
  const ErrorRowDetailsState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
