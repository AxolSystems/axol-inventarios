import 'package:equatable/equatable.dart';

import '../../model/product_model.dart';

abstract class ProductTabState extends Equatable {
  const ProductTabState();
}

class InitialProductTabState extends ProductTabState {
  @override
  List<Object?> get props => [];
}

class LoadingProductTabState extends ProductTabState {
  @override
  List<Object?> get props => [];
}

class LoadedProductTabState extends ProductTabState {
  final List<ProductModel> products;
  const LoadedProductTabState(
      {required this.products});
  @override
  List<Object?> get props => [products];
}

class EditState extends ProductTabState {
  @override
  List<Object?> get props => [];
}

class ErrorProductTabState extends ProductTabState {
  final String error;
  const ErrorProductTabState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}
