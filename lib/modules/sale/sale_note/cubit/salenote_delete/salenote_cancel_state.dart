import 'package:equatable/equatable.dart';

abstract class SaleNoteCancelState extends Equatable {
  const SaleNoteCancelState();
}

class InitialSaleNoteDeleteState extends SaleNoteCancelState {
  @override
  List<Object?> get props => [];
}

class LoadingSaleNoteCancelState extends SaleNoteCancelState {
  @override
  List<Object?> get props => [];
}

class LoadedSaleNoteDeleteState extends SaleNoteCancelState {
  @override
  List<Object?> get props => [];
}

class CloseSaleNoteCancelState extends SaleNoteCancelState {
  @override
  List<Object?> get props => [];
}

class ErrorSaleNoteCancelState extends SaleNoteCancelState {
  final String error;
  const ErrorSaleNoteCancelState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}