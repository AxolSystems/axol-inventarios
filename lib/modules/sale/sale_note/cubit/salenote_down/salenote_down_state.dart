import 'package:equatable/equatable.dart';

abstract class SaleNoteDownState extends Equatable {
  const SaleNoteDownState();
}

class InitialSaleNoteDownState extends SaleNoteDownState {
  @override
  List<Object?> get props => [];
}

class LoadingSaleNoteDownState extends SaleNoteDownState {
  @override
  List<Object?> get props => [];
}

class LoadedSaleNoteDownState extends SaleNoteDownState {
  @override
  List<Object?> get props => [];
}

class ErrorSaleNoteDownState extends SaleNoteDownState {
  final String error;
  const ErrorSaleNoteDownState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}