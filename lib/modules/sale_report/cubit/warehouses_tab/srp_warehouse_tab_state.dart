import 'package:equatable/equatable.dart';

import '../../../inventory_/inventory/model/warehouse_model.dart';

abstract class SrpWarehouseTabState extends Equatable {
  const SrpWarehouseTabState();
}

class InitialSrpWarehouseTabState extends SrpWarehouseTabState {
  @override
  List<Object?> get props => [];
}

class LoadingSrpWarehouseTabState extends SrpWarehouseTabState {
  @override
  List<Object?> get props => [];
}

class LoadedSrpWarehouseTabState extends SrpWarehouseTabState {
  final List<WarehouseModel> warehouseList;
  const LoadedSrpWarehouseTabState({required this.warehouseList});
  @override
  List<Object?> get props => [warehouseList];
}

class ErrorSrpWarehouseTabState extends SrpWarehouseTabState {
  final String error;
  const ErrorSrpWarehouseTabState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}