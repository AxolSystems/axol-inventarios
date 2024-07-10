import 'package:equatable/equatable.dart';

/// Estados de cubit para drawer de detalles de objetos.
abstract class RowDetailsState extends Equatable {
  const RowDetailsState();
}

/// Estado inicial del cubit.
class InitialRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera cuando se desarrolla un proceso.
class LoadingRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finaliza el estado de carga y muestra 
/// los resultados obtenidos de los procesos anteriores.
class LoadedRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

/// Estado de al que pasa una vez finalizado el proceso de guardado.
class SavedRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera cuando se encuentra en el estado de guardado.
class SavingRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

class DeletingRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}

class DeletedRowDetailsState extends RowDetailsState {
  @override
  List<Object?> get props => [];
}


/// Estado de error que aparece cuando se llega aun conflicto.
class ErrorRowDetailsState extends RowDetailsState {
  final String error;
  const ErrorRowDetailsState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
