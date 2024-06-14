import 'package:equatable/equatable.dart';

import '../../../user/model/user_model.dart';

abstract class SaleReportViewState extends Equatable {
  const SaleReportViewState();
}

class InitialSaleReportViewState extends SaleReportViewState {
  @override
  List<Object?> get props => [];
}

class LoadingSaleReportViewState extends SaleReportViewState {
  @override
  List<Object?> get props => [];
}

class LoadedSaleReportViewState extends SaleReportViewState {
  final UserModel user;
  const LoadedSaleReportViewState({required this.user});
  @override
  List<Object?> get props => [user];
}

class ErrorSaleReportViewState extends SaleReportViewState {
  final String error;
  const ErrorSaleReportViewState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}