import 'package:equatable/equatable.dart';

import '../../model/product_model.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();
}

class InitialProductDetailsState extends ProductDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadingProductDetailsState extends ProductDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadedProductDetailsState extends ProductDetailsState {
  @override
  List<Object?> get props => [];
}

class ErrorProductDetailsState extends ProductDetailsState {
  final String error;
  const ErrorProductDetailsState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}