import 'package:equatable/equatable.dart';

abstract class SaleDialogSaveState extends Equatable {
  const SaleDialogSaveState();
}

class InitialSaleDialogSaveState extends SaleDialogSaveState {
  @override
  List<Object?> get props => [];
}

class LoadingSaleDialogSaveState extends SaleDialogSaveState {
  @override
  List<Object?> get props => [];
}

class LoadedSaleDialogSaveState extends SaleDialogSaveState {
  @override
  List<Object?> get props => [];
}

class ErrorSaleDialogSaveState extends SaleDialogSaveState {
  final String error;
  const ErrorSaleDialogSaveState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}