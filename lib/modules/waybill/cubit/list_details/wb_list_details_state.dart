import 'package:equatable/equatable.dart';

abstract class WbListDetailsState extends Equatable {
  const WbListDetailsState();
}

class InitialWbListDetailsState extends WbListDetailsState {
  @override
  List<Object?> get props => [];
}

enum LoadingWbListDetails {main, downCsv, downPdf}

class LoadingWbListDetailsState extends WbListDetailsState {
  final LoadingWbListDetails loadingState;
  const LoadingWbListDetailsState({required this.loadingState});
  @override
  List<Object?> get props => [loadingState];
}

class LoadedWbListDetailsState extends WbListDetailsState {
  @override
  List<Object?> get props => [];
}

class ErrorWbListDetailsState extends WbListDetailsState {
  final String error;
  const ErrorWbListDetailsState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}