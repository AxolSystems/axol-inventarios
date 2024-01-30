import 'package:equatable/equatable.dart';

abstract class SaleNoteDeleteState extends Equatable {
  const SaleNoteDeleteState();
}

class InitialSaleNoteDeleteState extends SaleNoteDeleteState {
  @override
  List<Object?> get props => [];
}

class LoadingSaleNoteDeleteState extends SaleNoteDeleteState {
  @override
  List<Object?> get props => [];
}

class LoadedSaleNoteDeleteState extends SaleNoteDeleteState {
  @override
  List<Object?> get props => [];
}

class CloseSaleNoteDeleteState extends SaleNoteDeleteState {
  @override
  List<Object?> get props => [];
}

class ErrorSaleNoteDeleteState extends SaleNoteDeleteState {
  final String error;
  const ErrorSaleNoteDeleteState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}