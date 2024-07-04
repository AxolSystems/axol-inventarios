import 'package:equatable/equatable.dart';

import '../../model/vendor_add_form_model.dart';

abstract class VendorAddState extends Equatable {
  const VendorAddState();
}

class InitialVendorAddState extends VendorAddState {
  @override
  List<Object?> get props => [];
}

class LoadingVendorAddState extends VendorAddState {
  @override
  List<Object?> get props => [];
}

class LoadedVendorAddState extends VendorAddState {
  final VendorAddFormModel form;
  final int focusIndex;
  const LoadedVendorAddState({required this.form, required this.focusIndex});
  @override
  List<Object?> get props => [form, focusIndex];
}

class SavingVendorAddState extends VendorAddState {
  @override
  List<Object?> get props => [];
}

class SavedVendorAddState extends VendorAddState {
  @override
  List<Object?> get props => [];
}

class FailedSaveVendorAddState extends VendorAddState {
  @override
  List<Object?> get props => [];
}

class ErrorVendorAddState extends VendorAddState {
  final String error;
  const ErrorVendorAddState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}