import 'package:equatable/equatable.dart';

abstract class SrpDocDetailsState extends Equatable {
  const SrpDocDetailsState();
}

class InitialSrpDocDetailsState extends SrpDocDetailsState {
  @override
  List<Object?> get props => [];
}

enum LoadingSrpDocDetails {main, downCsv, downPdf}

class LoadingSrpDocDetailsState extends SrpDocDetailsState {
  final LoadingSrpDocDetails loadingState;
  const LoadingSrpDocDetailsState({required this.loadingState});
  @override
  List<Object?> get props => [loadingState];
}

class LoadedSrpDocDetailsState extends SrpDocDetailsState {
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