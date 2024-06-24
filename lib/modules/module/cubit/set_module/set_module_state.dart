import 'package:equatable/equatable.dart';

/// Estados del cubit de SetModuleCubit. Contiene los estados 
/// de la vista del widget de SetModuleWidget.
abstract class SetModuleState extends Equatable {
  const SetModuleState();
}

/// Estado inicial del widget.
class InitialSetModuleState extends SetModuleState {
  @override
  List<Object?> get props => [];
}

/// Estado de carga. Se recurre a este estado cuando se 
/// necesita esperar a la finalización de un proceso.
class LoadingSetModuleState extends SetModuleState {
  @override
  List<Object?> get props => [];
}

/// Estado una vez que se finalizaron los procesos fueron llamados.
class LoadedSetModuleState extends SetModuleState {
  @override
  List<Object?> get props => [];
}

/// Estado de error. Se recurre a estado cuando el sistema detecta un error.
class ErrorSetModuleState extends SetModuleState {
  final String error;
  const ErrorSetModuleState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}