import 'package:equatable/equatable.dart';

abstract class CustomerDeleteState extends Equatable {
  const CustomerDeleteState();
}

class InitialCustomerDeleteState extends CustomerDeleteState {
  @override
  List<Object?> get props => [];
}

class LoadingCustomerDeleteState extends CustomerDeleteState {
  @override
  List<Object?> get props => [];
}

class LoadedCustomerDeleteState extends CustomerDeleteState {
  @override
  List<Object?> get props => [];
}

class CloseCustomerDeleteState extends CustomerDeleteState {
  @override
  List<Object?> get props => [];
}

class ErrorCustomerDeleteState extends CustomerDeleteState {
  final String error;
  const ErrorCustomerDeleteState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}