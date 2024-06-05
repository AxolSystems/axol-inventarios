import 'package:equatable/equatable.dart';

abstract class MainViewState extends Equatable {
  const MainViewState();
}

class InitialMainViewState extends MainViewState {
  @override
  List<Object?> get props => [];
}

class LoadingMainViewState extends MainViewState {
  @override
  List<Object?> get props => [];
}

class LoadedMainViewState extends MainViewState {
  @override
  List<Object?> get props => [];
}

class SetThemeMainViewState extends MainViewState {
  final int theme;
  const SetThemeMainViewState({required this.theme});
  @override
  List<Object?> get props => [theme];
}

class ErrorMainViewState extends MainViewState {
  final String error;
  const ErrorMainViewState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
