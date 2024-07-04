import 'package:equatable/equatable.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../sale/vendor/model/vendor_model.dart';

abstract class VendorSelectState extends Equatable {
  const VendorSelectState();
}

class InitialState extends VendorSelectState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends VendorSelectState {
  final TextfieldModel textfieldFinder;
  const LoadingState({required this.textfieldFinder});
  @override
  List<Object?> get props => [textfieldFinder];
}

class LoadedState extends VendorSelectState {
  final List<VendorModel> vendorList;
  final TextfieldModel textfieldFinder;
  const LoadedState({required this.vendorList, required this.textfieldFinder});
  @override
  List<Object?> get props => [vendorList, textfieldFinder];
}

class ErrorState extends VendorSelectState {
  final String error;
  const ErrorState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
