import 'package:equatable/equatable.dart';

import '../../../inventory_/inventory/model/warehouse_model.dart';

abstract class WbWarehouseTabState extends Equatable {
  const WbWarehouseTabState();
}

class InitialWbWarehouseTabState extends WbWarehouseTabState {
  @override
  List<Object?> get props => [];
}

class LoadingWbWarehouseTabState extends WbWarehouseTabState {
  @override
  List<Object?> get props => [];
}

class LoadedWbWarehouseTabState extends WbWarehouseTabState {
  final List<WarehouseModel> warehouseList;
  const LoadedWbWarehouseTabState({required this.warehouseList});
  @override
  List<Object?> get props => [warehouseList];
}

class ErrorWbWarehouseTabState extends WbWarehouseTabState {
  final String error;
  const ErrorWbWarehouseTabState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}