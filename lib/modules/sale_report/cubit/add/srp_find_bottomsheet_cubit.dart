import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/inventory_row_model.dart';
import '../../model/srp_find_bottomsheet_form_model.dart';

enum SrpFindBottomsheetState { intital, loading, load, error, select }

class SrpFindBottomsheetCubit extends Cubit<SrpFindBottomsheetState> {
  SrpFindBottomsheetCubit() : super(SrpFindBottomsheetState.intital);

  Future<void> load(SrpFindBottomsheetFormModel form) async {
    try {
      emit(SrpFindBottomsheetState.intital);
      emit(SrpFindBottomsheetState.loading);
      emit(SrpFindBottomsheetState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(SrpFindBottomsheetState.error);
    }
  }

  Future<void> find(SrpFindBottomsheetFormModel form,
      List<InventoryRowModel> inventoryRowList) async {
    try {
      emit(SrpFindBottomsheetState.intital);
      emit(SrpFindBottomsheetState.loading);
      List<InventoryRowModel> upList;

      upList = inventoryRowList
          .where((x) =>
              (x.product.code.toLowerCase().replaceAll(' ', '').contains(
                  form.controller.text.toLowerCase().replaceAll(' ', ''))) ||
              (x.product.description.toLowerCase().replaceAll(' ', '').contains(
                  form.controller.text.replaceAll(' ', '').toLowerCase())))
          .toList();
      form.inventoryRowList = upList;

      emit(SrpFindBottomsheetState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(SrpFindBottomsheetState.error);
    }
  }

  Future<void> select(SrpFindBottomsheetFormModel form) async {
    try {
      emit(SrpFindBottomsheetState.intital);
      emit(SrpFindBottomsheetState.loading);
      final qty = double.tryParse(form.controller.text);

      if (qty == null) {
        form.errorMessage = 'Seleccione una cantidad.';
        return;
      }
      if (qty <= 0) {
        form.errorMessage = 'La cantidad debe ser mayor a cero.';
        return;
      }
      form.errorMessage = null;

      emit(SrpFindBottomsheetState.select);
      emit(SrpFindBottomsheetState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(SrpFindBottomsheetState.error);
    }
  }
}

class SrpFindBottomsheetForm extends Cubit<SrpFindBottomsheetFormModel> {
  SrpFindBottomsheetForm() : super(SrpFindBottomsheetFormModel.empty());
}