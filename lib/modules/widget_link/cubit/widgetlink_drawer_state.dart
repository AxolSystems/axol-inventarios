import 'package:equatable/equatable.dart';

abstract class WLinkDrawerState extends Equatable {
  const WLinkDrawerState();
}

class InitialWLinkDrawerState extends WLinkDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadingWLinkDrawerState extends WLinkDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadedWLinkDrawerState extends WLinkDrawerState {
  @override
  List<Object?> get props => [];
}

class ErrorWLinkDrawerState extends WLinkDrawerState {
  final String error;
  const ErrorWLinkDrawerState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}