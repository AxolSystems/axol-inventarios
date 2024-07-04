import 'package:equatable/equatable.dart';

import '../../../../../models/inventory_row_model.dart';

abstract class InventoryListState extends Equatable {
  const InventoryListState();
}

class InitialInventoryListState extends InventoryListState {
  @override
  List<Object?> get props => [];
}

class LoadingInventoryListState extends InventoryListState {
  @override
  List<Object?> get props => [];
}

class LoadedInventoryListState extends InventoryListState {
  final List<InventoryRowModel> inventoryRowList;
  const LoadedInventoryListState({required this.inventoryRowList});
  @override
  List<Object?> get props => [inventoryRowList];
}

class ErrorInventoryListState extends InventoryListState {
  final String error;
  const ErrorInventoryListState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}