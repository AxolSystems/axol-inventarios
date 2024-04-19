import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/srp_add_bottomsheet_form_model.dart';

enum SrpAddBottomsheetState { intital, loading, load, error, save }

enum SrpAddBottomsheetSubtState {add, edit}

class SrpAddBottomsheetCubit extends Cubit<SrpAddBottomsheetState> {
  SrpAddBottomsheetCubit() : super(SrpAddBottomsheetState.intital);

  Future<void> initLoad(
      SrpAddBottomsheetFormModel form, String initValue) async {
    try {
      emit(SrpAddBottomsheetState.intital);
      emit(SrpAddBottomsheetState.loading);

      emit(SrpAddBottomsheetState.load);
    } catch (e) {
      form.errorMessageQty = e.toString();
      emit(SrpAddBottomsheetState.error);
    }
  }

  Future<void> load(SrpAddBottomsheetFormModel form) async {
    try {
      emit(SrpAddBottomsheetState.intital);
      emit(SrpAddBottomsheetState.loading);
      emit(SrpAddBottomsheetState.load);
    } catch (e) {
      form.errorMessageQty = e.toString();
      emit(SrpAddBottomsheetState.error);
    }
  }

  Future<void> save(SrpAddBottomsheetFormModel form) async {
    try {
      emit(SrpAddBottomsheetState.intital);
      emit(SrpAddBottomsheetState.loading);
      final qty = double.tryParse(form.qtyCtrl.text);
      final unitPrice = double.tryParse(form.unitPriceCtrl.text);
      bool isQtyValid = true;
      bool isPriceValid = true;

      if (qty == null && isQtyValid) {
        form.errorMessageQty = 'Seleccione una cantidad.';
        isQtyValid = false;
      } else if (qty > form.stock && isQtyValid) {
        form.errorMessageQty = 'La cantidad no puede ser mayor al stock.';
        isQtyValid = false;
      } else if (qty <= 0 && isQtyValid) {
        form.errorMessageQty = 'La cantidad debe ser mayor a cero.';
        isQtyValid = false;
      }
      if (isQtyValid) {
        form.errorMessageQty = null;
      }

      if (unitPrice == null && isPriceValid) {
        form.errorMessagePrice = 'Seleccione un precio valido';
        isPriceValid = false;
      }
      if (isPriceValid) {
        form.errorMessagePrice = null;
      }

      emit(SrpAddBottomsheetState.save);
      emit(SrpAddBottomsheetState.load);
    } catch (e) {
      form.errorMessageQty = e.toString();
      emit(SrpAddBottomsheetState.error);
    }
  }
}

class SrpAddBottomsheetForm extends Cubit<SrpAddBottomsheetFormModel> {
  SrpAddBottomsheetForm() : super(SrpAddBottomsheetFormModel.empty());
}