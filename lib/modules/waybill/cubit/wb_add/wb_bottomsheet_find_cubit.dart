import 'package:axol_inventarios/models/inventory_row_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/wb_bottomsheet_find_form_model.dart';

enum WbBottomSheetFindState { intital, loading, load, error, select }

class WbBottomSheetFindCubit extends Cubit<WbBottomSheetFindState> {
  WbBottomSheetFindCubit() : super(WbBottomSheetFindState.intital);

  Future<void> load(WbBottomSheetFindFormModel form) async {
    try {
      emit(WbBottomSheetFindState.intital);
      emit(WbBottomSheetFindState.loading);
      emit(WbBottomSheetFindState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbBottomSheetFindState.error);
    }
  }

  Future<void> find(WbBottomSheetFindFormModel form,
      List<InventoryRowModel> inventoryRowList) async {
    try {
      emit(WbBottomSheetFindState.intital);
      emit(WbBottomSheetFindState.loading);
      List<InventoryRowModel> upList;

      upList = inventoryRowList
          .where((x) =>
              (x.product.code.toLowerCase().replaceAll(' ', '').contains(
                  form.controller.text.toLowerCase().replaceAll(' ', ''))) ||
              (x.product.description.toLowerCase().replaceAll(' ', '').contains(
                  form.controller.text.replaceAll(' ', '').toLowerCase())))
          .toList();
      form.inventoryRowList = upList;

      emit(WbBottomSheetFindState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbBottomSheetFindState.error);
    }
  }

  Future<void> select(WbBottomSheetFindFormModel form) async {
    try {
      emit(WbBottomSheetFindState.intital);
      emit(WbBottomSheetFindState.loading);
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

      emit(WbBottomSheetFindState.select);
      emit(WbBottomSheetFindState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbBottomSheetFindState.error);
    }
  }
}

class WbBottomSheetFindForm extends Cubit<WbBottomSheetFindFormModel> {
  WbBottomSheetFindForm() : super(WbBottomSheetFindFormModel.empty());
}
