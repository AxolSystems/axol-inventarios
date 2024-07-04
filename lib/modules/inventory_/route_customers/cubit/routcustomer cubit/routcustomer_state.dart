import 'package:axol_inventarios/models/textfield_model.dart';
import 'package:equatable/equatable.dart';

import '../../model/routcustomer_model.dart';

abstract class RoutcustomerState extends Equatable {
  const RoutcustomerState();
}

class InitialState extends RoutcustomerState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends RoutcustomerState {
  final TextfieldModel textfieldFinder;
  const LoadingState({required this.textfieldFinder});
  @override
  List<Object?> get props => [textfieldFinder];
}

class LoadedState extends RoutcustomerState {
  final List<RoutcustomerModel> rcList;
  final TextfieldModel textfieldFinder;
  const LoadedState({required this.rcList, required this.textfieldFinder});
  @override
  List<Object?> get props => [rcList, textfieldFinder];
}

class ErrorState extends RoutcustomerState {
  final String error;
  const ErrorState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
