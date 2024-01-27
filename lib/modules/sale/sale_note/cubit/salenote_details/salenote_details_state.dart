import 'package:equatable/equatable.dart';

import '../../../../inventory_/product/model/product_model.dart';

abstract class SaleNoteDetailsState extends Equatable {
  const SaleNoteDetailsState();
}

class InitialSaleNoteDetailsState extends SaleNoteDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadingSaleNoteDetailsState extends SaleNoteDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadedSaleNoteDetailsState extends SaleNoteDetailsState {
  final ProductModel product;
  const LoadedSaleNoteDetailsState({required this.product});
  @override
  List<Object?> get props => [product];
}

class ErrorSaleNoteDetailsState extends SaleNoteDetailsState {
  final String error;
  const ErrorSaleNoteDetailsState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}