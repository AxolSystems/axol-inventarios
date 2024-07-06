import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Estados cubit de vista de tabla.
abstract class TableState extends Equatable {
  const TableState();
}

/// Estado inicial de cubit de vista de tabla.
class InitialTableState extends TableState {
  @override
  List<Object?> get props => [];
}

/// Estado de carga. Pasa a este estado cuando
/// algún proceso de la vista de tabla requiere
/// la espera de su finalización.
class LoadingTableState extends TableState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finalizaron los
/// procesos asíncronos que requerían de su espera.
class LoadedTableState extends TableState {
  @override
  List<Object?> get props => [];
}

/// Estado de espera para el método de guardado.
/// Las acciones a mostrar en pantalla son distintas
/// a *LoadingTableState*, razón por la que se tiene que
/// utilizar un estado distinto.
class SavingTableState extends TableState {
  @override
  List<Object?> get props => [];
}

/// Estado al que pasa una vez finalizado el estado
/// de *SavingTableState*.
class SavedTableState extends TableState {
  final String text;
  const SavedTableState(this.text);
  @override
  List<Object?> get props => [text];
}

/// Estado de error. Estado al que pasa si se
/// detecta un error interno del sistema.
///
/// - [error] : Texto que describe el error detectado.
class ErrorTableState extends TableState {
  final String error;
  const ErrorTableState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
