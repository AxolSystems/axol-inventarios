import 'package:axol_inventarios/modules/sale/vendor/model/vendor_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../user/model/user_mdoel.dart';

abstract class VendorTabState extends Equatable {
  const VendorTabState();
}

class InitialVendorTabState extends VendorTabState {
  @override
  List<Object?> get props => [];
}

class LoadingVendorTabState extends VendorTabState {
  final UserModel user;
  const LoadingVendorTabState({required this.user});
  @override
  List<Object?> get props => [user];
}

class LoadedVendorTabState extends VendorTabState {
  final List<VendorModel> vendorList;
  final UserModel user;
  const LoadedVendorTabState({required this.vendorList, required this.user});
  @override
  List<Object?> get props => [vendorList];
}

class ErrorVendorTabState extends VendorTabState {
  final String error;
  const ErrorVendorTabState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}