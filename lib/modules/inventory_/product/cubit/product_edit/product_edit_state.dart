import 'package:equatable/equatable.dart';

abstract class ProductEditState extends Equatable {
  const ProductEditState();
}

class InitialProductEditState extends ProductEditState {
  @override
  List<Object?> get props => [];
}

class LoadingProductEditState extends ProductEditState {
  @override
  List<Object?> get props => [];
}

class LoadedProductEditState extends ProductEditState {
  @override
  List<Object?> get props => [];
}

class SavedProductEditState extends ProductEditState {
  @override
  List<Object?> get props => [];
}

class ErrorProductEditState extends ProductEditState {
  final String error;
  const ErrorProductEditState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}