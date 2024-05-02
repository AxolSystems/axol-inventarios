import 'package:equatable/equatable.dart';

abstract class SntDownDialogState extends Equatable {
  const SntDownDialogState();
}

class InitialSntDownDialogState extends SntDownDialogState {
  @override
  List<Object?> get props => [];
}

class LoadingSntDownDialogState extends SntDownDialogState {
  final bool btnDownLoading;
  const LoadingSntDownDialogState({required this.btnDownLoading});
  @override
  List<Object?> get props => [btnDownLoading];
}

class LoadedSntDownDialogState extends SntDownDialogState {
  @override
  List<Object?> get props => [];
}

class DownloadedSntDownDialogState extends SntDownDialogState {
  @override
  List<Object?> get props => [];
}

class ErrorSntDownDialogState extends SntDownDialogState {
  final String error;
  const ErrorSntDownDialogState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}