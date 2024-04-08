import 'package:equatable/equatable.dart';

import '../../../user/model/user_mdoel.dart';

abstract class WaybillViewState extends Equatable {
  const WaybillViewState();
}

class InitialWaybillViewState extends WaybillViewState {
  @override
  List<Object?> get props => [];
}

class LoadingWaybillViewState extends WaybillViewState {
  @override
  List<Object?> get props => [];
}

class LoadedWaybillViewState extends WaybillViewState {
  final UserModel user;
  const LoadedWaybillViewState({required this.user});
  @override
  List<Object?> get props => [user];
}

class ErrorWaybillViewState extends WaybillViewState {
  final String error;
  const ErrorWaybillViewState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}