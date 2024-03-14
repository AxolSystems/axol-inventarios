import 'package:equatable/equatable.dart';

abstract class InventoryDialogSaveState extends Equatable {
  const InventoryDialogSaveState();
}

class InitialInventoryDialogSaveState extends InventoryDialogSaveState {
  @override
  List<Object?> get props => [];
}

class LoadingInventoryDialogSaveState extends InventoryDialogSaveState {
  @override
  List<Object?> get props => [];
}

class LoadedInventoryDialogSaveState extends InventoryDialogSaveState {
  @override
  List<Object?> get props => [];
}

class ErrorInventoryDialogSaveState extends InventoryDialogSaveState {
  final String error;
  const ErrorInventoryDialogSaveState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}