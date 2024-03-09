import 'package:equatable/equatable.dart';

abstract class InventoryMoveState extends Equatable {
  const InventoryMoveState();
}

class InitialInventoryMoveState extends InventoryMoveState {
  @override
  List<Object?> get props => [];
}

class LoadingInventoryMoveState extends InventoryMoveState {
  @override
  List<Object?> get props => [];
}

class LoadedInventoryMoveState extends InventoryMoveState {
  @override
  List<Object?> get props => [];
}

class SavedInventoryMoveState extends InventoryMoveState {
  @override
  List<Object?> get props => [];
}

class ErrorInventoryMoveState extends InventoryMoveState {
  final String error;
  const ErrorInventoryMoveState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}