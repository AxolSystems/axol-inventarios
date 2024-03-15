import 'package:equatable/equatable.dart';

abstract class MovementPdfState extends Equatable {
  const MovementPdfState();
}

class InitialMovePdfState extends MovementPdfState {
  @override
  List<Object?> get props => [];
}

class LoadingMovePdfState extends MovementPdfState {
  @override
  List<Object?> get props => [];
}

class LoadedMovePdfState extends MovementPdfState {
  @override
  List<Object?> get props => [];
}

class ErrorMovePdfState extends MovementPdfState {
  final String error;
  const ErrorMovePdfState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}