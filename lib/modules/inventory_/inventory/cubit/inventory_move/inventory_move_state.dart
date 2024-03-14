import 'package:equatable/equatable.dart';

import '../../model/report_inventory_move_model.dart';

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
  final ReportInventoryMoveModel reportData;
  const SavedInventoryMoveState({required this.reportData});
  @override
  List<Object?> get props => [reportData];
}

class ErrorInventoryMoveState extends InventoryMoveState {
  final String error;
  const ErrorInventoryMoveState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}