import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/wb_bottomsheet_form_model.dart';

enum WbAddDrawerState { intital, loading, load, error, save }

class WbAddDrawerCubit extends Cubit<WbAddDrawerState> {
  WbAddDrawerCubit() : super(WbAddDrawerState.intital);

  Future<void> initLoad(
      WbDrawerAddFormModel form, String initValue) async {
    try {
      emit(WbAddDrawerState.intital);
      emit(WbAddDrawerState.loading);
      //form.itemValue = initValue;
      emit(WbAddDrawerState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbAddDrawerState.error);
    }
  }

  Future<void> load(WbDrawerAddFormModel form) async {
    try {
      emit(WbAddDrawerState.intital);
      emit(WbAddDrawerState.loading);
      emit(WbAddDrawerState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbAddDrawerState.error);
    }
  }

  Future<void> save(WbDrawerAddFormModel form) async {
    try {
      emit(WbAddDrawerState.intital);
      emit(WbAddDrawerState.loading);
      final qty = double.tryParse(form.qtyCtrl.text);

      if (qty == null) {
        form.errorMessage = 'Seleccione una cantidad.';
        return;
      }
      if (qty > form.stock) {
        form.errorMessage = 'La cantidad no puede ser mayor al stock.';
        return;
      }
      if (qty <= 0) {
        form.errorMessage = 'La cantidad debe ser mayor a cero.';
        return;
      }
      form.errorMessage = null;

      emit(WbAddDrawerState.save);
      emit(WbAddDrawerState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbAddDrawerState.error);
    }
  }
}

class WbDrawerAddForm extends Cubit<WbDrawerAddFormModel> {
  WbDrawerAddForm() : super(WbDrawerAddFormModel.empty());
  WbDrawerAddForm.set(WbDrawerAddFormModel form)
      : super(WbDrawerAddFormModel.set(form));
}
