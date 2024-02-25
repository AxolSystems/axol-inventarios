import 'package:equatable/equatable.dart';

import '../../model/warehouse_model.dart';

abstract class WarehouseTabState extends Equatable {
  const WarehouseTabState();
}

class InitialWarehouseTabState extends WarehouseTabState {
  @override
  List<Object?> get props => [];
}

class LoadingWarehouseTabState extends WarehouseTabState {
  @override
  List<Object?> get props => [];
}

class LoadedWarehouseTabState extends WarehouseTabState {
  final List<WarehouseModel> warehouseList;
  const LoadedWarehouseTabState({required this.warehouseList});
  @override
  List<Object?> get props => [warehouseList];
}

class ErrorWarehouseTabState extends WarehouseTabState {
  final String error;
  const ErrorWarehouseTabState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}