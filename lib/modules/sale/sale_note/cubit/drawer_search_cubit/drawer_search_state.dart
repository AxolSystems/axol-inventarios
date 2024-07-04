import 'package:axol_inventarios/modules/sale/customer/model/customer_model.dart';
import 'package:equatable/equatable.dart';

abstract class DrawerSearchState extends Equatable {
  const DrawerSearchState();
}

class InitialState extends DrawerSearchState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends DrawerSearchState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends DrawerSearchState {
  final List<CustomerModel> listData;
  const LoadedState({required this.listData});
  @override
  List<Object?> get props => [listData];
}

class ErrorState extends DrawerSearchState {
  final String error;
  const ErrorState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
