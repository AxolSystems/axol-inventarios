import 'package:equatable/equatable.dart';

/// Estados de cubit de MainView.
abstract class MainViewState extends Equatable {
  const MainViewState();
}

/// Estado inicial de MainView.
class InitialMainViewState extends MainViewState {
  @override
  List<Object?> get props => [];
}

/// Estado de carga de MainView. Este se suele 
/// utilizar cuando se tine que esperar a recibir 
/// un dato de una manera asíncrona.
class LoadingMainViewState extends MainViewState {
  @override
  List<Object?> get props => [];
}

/// Estado en el que se muestra la vista una vez se 
/// haya terminado cargar los métodos que estaban en 
/// espera de ser finalizados.
class LoadedMainViewState extends MainViewState {
  @override
  List<Object?> get props => [];
}

/// Estado que indica el cambio de tema.
class SetThemeMainViewState extends MainViewState {
  final int theme;
  const SetThemeMainViewState({required this.theme});
  @override
  List<Object?> get props => [theme];
}

/// Estado de error en MainView. Si se detecta algún 
/// error en la vista, se recibe este estado.
class ErrorMainViewState extends MainViewState {
  final String error;
  const ErrorMainViewState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
