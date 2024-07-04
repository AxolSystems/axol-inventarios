import 'package:equatable/equatable.dart';

abstract class PasswordVisibilityState extends Equatable {}

class PVIsVisibleState extends PasswordVisibilityState {
  @override
  String toString() => 'IsVisible';

  @override
  List<Object?> get props => [];
}

class PVIsNotVisibleState extends PasswordVisibilityState {
  @override
  String toString() => 'IsNotVisible';

  @override
  List<Object?> get props => [];
}

class PVErrorState extends PasswordVisibilityState {
  final String error;

  PVErrorState({required this.error});

  @override
  String toString() => 'Error: $error';

  @override
  List<Object?> get props => [];
}
