import 'package:equatable/equatable.dart';

/// Estados de drawer para buscar widgetLinks.
abstract class WLinkDrawerState extends Equatable {
  const WLinkDrawerState();
}

// Estado inicial de drawer.
class InitialWLinkDrawerState extends WLinkDrawerState {
  @override
  List<Object?> get props => [];
}

/// Estado de carga. Este estado se interpone si hay un 
/// procesos que se requiera la espera de su finalización.
class LoadingWLinkDrawerState extends WLinkDrawerState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finalizado el estado de 
/// carga, actualizando vista y datos al usuario.
class LoadedWLinkDrawerState extends WLinkDrawerState {
  @override
  List<Object?> get props => [];
}

/// Estado de error que emerge si el sistema detecta un problema.
class ErrorWLinkDrawerState extends WLinkDrawerState {
  final String error;
  const ErrorWLinkDrawerState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}