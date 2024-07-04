import 'package:equatable/equatable.dart';

abstract class VendorDeleteState extends Equatable {
  const VendorDeleteState();
}

class InitialVendorDeleteState extends VendorDeleteState {
  @override
  List<Object?> get props => [];
}

class LoadingVendorDeleteState extends VendorDeleteState {
  @override
  List<Object?> get props => [];
}

class LoadedVendorDeleteState extends VendorDeleteState {
  @override
  List<Object?> get props => [];
}

class CloseVendorDeleteState extends VendorDeleteState {
  @override
  List<Object?> get props => [];
}

class ErrorVendorDeleteState extends VendorDeleteState {
  final String error;
  const ErrorVendorDeleteState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}