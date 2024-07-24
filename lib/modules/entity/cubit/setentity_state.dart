import 'package:equatable/equatable.dart';
/// Clase abstracta de donde heredan los estados 
/// de la vista de ajustes de bloque.
abstract class SetEntityState extends Equatable {
  const SetEntityState();
}

/// Estado inicial de la vista de ajustes del bloque.
class InitialSetEntityState extends SetEntityState {
  @override
  List<Object?> get props => [];
}

/// Estado de carga. Este estado se ejecuta cuando 
/// se tiene que esperar a que un proceso en la lógica 
/// del negocio finalice.
class LoadingSetEntityState extends SetEntityState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finalizado los procesos 
/// que se tenían en espera.
class LoadedSetEntityState extends SetEntityState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera al guardar. Lo que muestra en 
/// pantalla es distinto a otros tipos de carga, 
/// razón por la que se debe utilizar un estado 
/// diferente a [LoadingSetEntityState].
class SavingSetEntityState extends SetEntityState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finalizó el proceso 
/// de guardado. Se utiliza este estado en lugar de 
/// LoadedSetEntityState, ya que al finalizar el estado 
/// de guardado se realizarán acciones diferentes.
class SavedSetEntityState extends SetEntityState {
  @override
  List<Object?> get props => [];
}

/// Estado de error que indicara al usuario que algo salió mal.
/// 
/// - [error] : Envía un texto con la descripción del error.
class ErrorSetEntityState extends SetEntityState {
  final String error;
  const ErrorSetEntityState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}