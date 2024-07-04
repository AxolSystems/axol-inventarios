import 'package:equatable/equatable.dart';

import '../../model/user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitialState extends LoginState {
  @override
  String toString() => 'LoginInitialState';

  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends LoginState {
  final UserModel user;

  const LoginSuccessState({required this.user});

  @override
  String toString() => 'LoginSuccessState';

  @override
  List<Object?> get props => [user];
}

class LoginFailureState extends LoginState {
  @override
  String toString() => 'LoginFailure';

  @override
  List<Object?> get props => [];
}

class LoginErrorState extends LoginState {
  final String error;

  const LoginErrorState({required this.error});

  @override
  String toString() => 'Error: $error';

  @override
  List<Object?> get props => [error];
}
