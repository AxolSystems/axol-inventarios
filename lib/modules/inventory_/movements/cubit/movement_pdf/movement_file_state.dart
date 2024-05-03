import 'package:equatable/equatable.dart';

abstract class MovementPdfState extends Equatable {
  const MovementPdfState();
}

class InitialMovePdfState extends MovementPdfState {
  @override
  List<Object?> get props => [];
}

class LoadingMoveFileState extends MovementPdfState {
  @override
  List<Object?> get props => [];
}

class LoadedMoveFileState extends MovementPdfState {
  @override
  List<Object?> get props => [];
}

class ErrorMoveFileState extends MovementPdfState {
  final String error;
  const ErrorMoveFileState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}