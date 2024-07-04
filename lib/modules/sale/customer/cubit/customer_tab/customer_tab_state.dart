import 'package:equatable/equatable.dart';

import '../../model/customer_model.dart';

abstract class CustomerTabState extends Equatable {
  const CustomerTabState();
}

class InitialCustomerTabState extends CustomerTabState {
  @override
  List<Object?> get props => [];
}

class LoadingCustomerTabState extends CustomerTabState {
  @override
  List<Object?> get props => [];
}

class LoadedCustomerTabState extends CustomerTabState {
  final List<CustomerModel> customerList;
  const LoadedCustomerTabState({required this.customerList});
  @override
  List<Object?> get props => [customerList];
}

class ErrorCustomerTabState extends CustomerTabState {
  final String error;
  const ErrorCustomerTabState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}