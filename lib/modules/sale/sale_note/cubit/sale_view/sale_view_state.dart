import 'package:equatable/equatable.dart';

import '../../../../user/model/user_model.dart';

abstract class SaleViewState extends Equatable {
  const SaleViewState();
}

class InitialSaleViewState extends SaleViewState {
  @override
  List<Object?> get props => [];
}

class LoadingSaleViewState extends SaleViewState {
  @override
  List<Object?> get props => [];
}

class LoadedSaleViewState extends SaleViewState {
  final UserModel user;
  const LoadedSaleViewState({required this.user});
  @override
  List<Object?> get props => [user];
}

class ErrorSaleViewState extends SaleViewState {
  final String error;
  const ErrorSaleViewState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}