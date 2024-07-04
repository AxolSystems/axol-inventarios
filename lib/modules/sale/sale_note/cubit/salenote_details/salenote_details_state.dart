import 'package:equatable/equatable.dart';
import '../../model/sale_product_model.dart';

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
  final List<SaleProductModel> productList;
  const LoadedSaleNoteDetailsState({required this.productList});
  @override
  List<Object?> get props => [productList];
}

class ErrorSaleNoteDetailsState extends SaleNoteDetailsState {
  final String error;
  const ErrorSaleNoteDetailsState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}