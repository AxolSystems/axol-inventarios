import 'package:equatable/equatable.dart';

import '../../model/salereport_model.dart';

abstract class SrpDoclistState extends Equatable {
  const SrpDoclistState();
}

class InitialSrpDoclistState extends SrpDoclistState {
  @override
  List<Object?> get props => [];
}

class LoadingSrpDoclistState extends SrpDoclistState {
  @override
  List<Object?> get props => [];
}

class LoadedSrpDoclistState extends SrpDoclistState {
  @override
  List<Object?> get props => [];
}

class OpenDetailsSrpDoclistState extends SrpDoclistState {
  final SaleReportModel saleReport;
  const OpenDetailsSrpDoclistState({required this.saleReport});
  @override
  List<Object?> get props => [saleReport];
}

class ErrorSrpDoclistState extends SrpDoclistState {
  final String error;
  const ErrorSrpDoclistState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}