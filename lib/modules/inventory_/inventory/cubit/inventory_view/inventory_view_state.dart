import 'package:equatable/equatable.dart';

import '../../../../user/model/user_mdoel.dart';

abstract class InventoryViewState extends Equatable {
  const InventoryViewState();
}

class InitialInventoryViewState extends InventoryViewState {
  @override
  List<Object?> get props => [];
}

class LoadingInventoryViewState extends InventoryViewState {
  @override
  List<Object?> get props => [];
}

class LoadedInventoryViewState extends InventoryViewState {
  final UserModel user;
  const LoadedInventoryViewState({required this.user});
  @override
  List<Object?> get props => [user];
}

class ErrorInventoryViewState extends InventoryViewState {
  final String error;
  const ErrorInventoryViewState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}