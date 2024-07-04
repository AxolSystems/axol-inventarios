import 'package:equatable/equatable.dart';

abstract class InvDownloadDrawerState extends Equatable {
  const InvDownloadDrawerState();
}

class InitialInvDownloadDrawerState extends InvDownloadDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadingInvDownloadDrawerState extends InvDownloadDrawerState {
  @override
  List<Object?> get props => [];
}

class LoadedInvDownloadDrawerState extends InvDownloadDrawerState {
  @override
  List<Object?> get props => [];
}

class ErrorInvDownloadDrawerState extends InvDownloadDrawerState {
  final String error;
  const ErrorInvDownloadDrawerState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}