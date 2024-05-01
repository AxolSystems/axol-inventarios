import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/product_edit_form_model.dart';
import '../../model/product_model.dart';
import '../../repository/product_repo.dart';
import 'product_edit_state.dart';

class ProductEditCubit extends Cubit<ProductEditState> {
  ProductEditCubit() : super(InitialProductEditState());

  Future<void> initLoad(ProductModel product, ProductEditFormModel form) async {
    try {
      emit(InitialProductEditState());
      emit(LoadingProductEditState());
      form.tfCapacity.controller.value = TextEditingValue(
        text: product.capacity ?? '',
        selection:
            TextSelection.collapsed(offset: product.capacity?.length ?? 0),
      );
      form.tfDescription.controller.value = TextEditingValue(
        text: product.description,
        selection: TextSelection.collapsed(offset: product.description.length),
      );
      form.tfGauge.controller.value = TextEditingValue(
        text: '${product.gauge ?? ''}',
        selection: TextSelection.collapsed(
            offset: product.gauge?.toString().length ?? 0),
      );
      form.tfMasure.controller.value = TextEditingValue(
        text: product.measure ?? '',
        selection:
            TextSelection.collapsed(offset: product.measure?.length ?? 0),
      );
      form.tfPacking.controller.value = TextEditingValue(
        text: product.packing ?? '',
        selection:
            TextSelection.collapsed(offset: product.packing?.length ?? 0),
      );
      form.tfPices.controller.value = TextEditingValue(
        text: product.pieces ?? '',
        selection: TextSelection.collapsed(offset: product.pieces?.length ?? 0),
      );
      form.tfType.controller.value = TextEditingValue(
        text: product.type ?? '',
        selection: TextSelection.collapsed(offset: product.type?.length ?? 0),
      );
      form.tfWeight.controller.value = TextEditingValue(
        text: '${product.weight ?? ''}',
        selection: TextSelection.collapsed(
            offset: product.capacity?.toString().length ?? 0),
      );
      form.tfPrice.controller.value = TextEditingValue(
        text: product.price.toString(),
        selection:
            TextSelection.collapsed(offset: product.price.toString().length),
      );
      form.tfUnitSale.controller.value = TextEditingValue(
        text: product.unitSale,
        selection:
            TextSelection.collapsed(offset: product.unitSale.toString().length),
      );
      form.class_ = product.class_;
      emit(LoadedProductEditState());
    } catch (e) {
      emit(ErrorProductEditState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialProductEditState());
      emit(LoadingProductEditState());
      emit(LoadedProductEditState());
    } catch (e) {
      emit(ErrorProductEditState(error: e.toString()));
    }
  }

  Future<void> save(
      ProductEditFormModel form, String code, double price) async {
    try {
      emit(InitialProductEditState());
      emit(LoadingProductEditState());
      ProductModel product = ProductModel(
          class_: form.class_,
          code: code,
          description: form.tfDescription.controller.text,
          price: double.parse(form.tfPrice.controller.text),
          unitSale: form.tfUnitSale.controller.text,
          properties: {
            ProductModel.tCode: code,
            ProductModel.tType: form.tfType.controller.text,
            ProductModel.tGauge: form.tfGauge.controller.text,
            ProductModel.tPieces: form.tfPices.controller.text,
            ProductModel.tWeight: form.tfWeight.controller.text,
            ProductModel.tMeasure: form.tfMasure.controller.text,
            ProductModel.tPacking: form.tfPacking.controller.text,
            ProductModel.tCapacity: form.tfCapacity.controller.text,
            ProductModel.tDescription: form.tfDescription.controller.text,
          });
      await ProductRepo().update(product);
      emit(LoadedProductEditState());
      emit(SavedProductEditState());
    } catch (e) {
      emit(ErrorProductEditState(error: e.toString()));
    }
  }
}
