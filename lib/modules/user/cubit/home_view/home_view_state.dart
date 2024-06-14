import 'package:equatable/equatable.dart';

import '../../model/user_model.dart';

abstract class HomeViewState extends Equatable {
  const HomeViewState();
}

class InitialHomeViewState extends HomeViewState {
  @override
  List<Object?> get props => [];
}

class LoadingHomeViewState extends HomeViewState {
  @override
  List<Object?> get props => [];
}

class LoadedHomeViewState extends HomeViewState {
  final UserModel user;
  const LoadedHomeViewState({required this.user});
  @override
  List<Object?> get props => [user];
}

class ErrorHomeViewState extends HomeViewState {
  final String error;
  const ErrorHomeViewState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}