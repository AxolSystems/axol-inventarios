import 'package:equatable/equatable.dart';

abstract class SrpDocDetailsState extends Equatable {
  const SrpDocDetailsState();
}

class InitialSrpDocDetailsState extends SrpDocDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadingSrpDocDetailsState extends SrpDocDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadedSrpDocDetailsState extends SrpDocDetailsState {
  @override
  List<Object?> get props => [];
}

class OpenDetailsSrpDocDetailsState extends SrpDocDetailsState {
  @override
  List<Object?> get props => [];
}

class ErrorSrpDocDetailsState extends SrpDocDetailsState {
  final String error;
  const ErrorSrpDocDetailsState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}