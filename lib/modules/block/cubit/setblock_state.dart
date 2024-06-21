import 'package:equatable/equatable.dart';
/// Clase abstracta de donde heredan los estados 
/// de la vista de ajustes de bloque.
abstract class SetBlockState extends Equatable {
  const SetBlockState();
}

/// Estado inicial de la vista de ajustes del bloque.
class InitialSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

/// Estado de carga. Este estado se ejecuta cuando 
/// se tiene que esperar a que un proceso en la lógica 
/// del negocio finalice.
class LoadingSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finalizado los procesos 
/// que se tenían en espera.
class LoadedSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera al guardar. Lo que muestra en 
/// pantalla es distinto a otros tipos de carga, 
/// razón por la que se debe utilizar un estado 
/// diferente a [LoadingSetBlockState].
class SavingSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finalizó el proceso 
/// de guardado. Se utiliza este estado en lugar de 
/// LoadedSetBlockState, ya que al finalizar el estado 
/// de guardado se realizarán acciones diferentes.
class SavedSetBlockState extends SetBlockState {
  @override
  List<Object?> get props => [];
}

/// Estado de error que indicara al usuario que algo salió mal.
/// 
/// - [error] : Envía un texto con la descripción del error.
class ErrorSetBlockState extends SetBlockState {
  final String error;
  const ErrorSetBlockState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}