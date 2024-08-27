import 'package:equatable/equatable.dart';

import '../../../object/model/object_model.dart';

abstract class FormDrawerState extends Equatable {
  const FormDrawerState();
}

/// Estado inicial de cubit para widget de formulario.
class InitialFormState extends FormDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadingFormState extends FormDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadedFormState extends FormDrawerState {
  @override
  List<Object?> get props => [];
}

class SavingFormState extends FormDrawerState {
  @override
  List<Object?> get props => [];
}

class SavedFormState extends FormDrawerState {
  final ObjectModel object;
  const SavedFormState({required this.object});
  @override
  List<Object?> get props => [object];
}

/// Estado de error. Estado al que pasa si se
/// detecta un error interno del sistema.
///
/// - [error] : Texto que describe el error detectado.
class ErrorFormState extends FormDrawerState {
  final String error;
  const ErrorFormState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}