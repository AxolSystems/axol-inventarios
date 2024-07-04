import 'package:equatable/equatable.dart';

import '../../model/customer_add_form_model.dart';

abstract class CustomerAddState extends Equatable {
  const CustomerAddState();
}

class InitialCustomerAddState extends CustomerAddState {
  @override
  List<Object?> get props => [];
}

class LoadingCustomerAddState extends CustomerAddState {
  @override
  List<Object?> get props => [];
}

class LoadedCustomerAddState extends CustomerAddState {
  final CustomerAddFormModel form;
  final int focusIndex;
  const LoadedCustomerAddState({required this.form, required this.focusIndex});
  @override
  List<Object?> get props => [form, focusIndex];
}

class SavingCustomerAddState extends CustomerAddState {
  @override
  List<Object?> get props => [];
}

class SavedCustomerAddState extends CustomerAddState {
  @override
  List<Object?> get props => [];
}

class FailedSaveCustomerAddState extends CustomerAddState {
  @override
  List<Object?> get props => [];
}

class ErrorCustomerAddState extends CustomerAddState {
  final String error;
  const ErrorCustomerAddState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}