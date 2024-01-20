import 'package:equatable/equatable.dart';

abstract class SaleNoteNoteState extends Equatable {
  const SaleNoteNoteState();
}

class InitialSaleNoteNoteState extends SaleNoteNoteState {
  @override
  List<Object?> get props => [];
}

class LoadingSaleNoteNoteState extends SaleNoteNoteState {
  @override
  List<Object?> get props => [];
}

class LoadedSaleNoteNoteState extends SaleNoteNoteState {
  @override
  List<Object?> get props => [];
}

class ErrorSaleNoteNoteState extends SaleNoteNoteState {
  final String error;
  const ErrorSaleNoteNoteState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}