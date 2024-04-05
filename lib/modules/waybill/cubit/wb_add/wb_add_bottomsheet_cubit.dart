import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/wb_bottomsheet_form_model.dart';

enum WbAddBottomSheetState { intital, loading, load, error, save }

class WbAddBottomSheetCubit extends Cubit<WbAddBottomSheetState> {
  WbAddBottomSheetCubit() : super(WbAddBottomSheetState.intital);

  Future<void> initLoad(
      WbBottomSheetAddFormModel form, String initValue) async {
    try {
      emit(WbAddBottomSheetState.intital);
      emit(WbAddBottomSheetState.loading);
      //form.itemValue = initValue;
      emit(WbAddBottomSheetState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbAddBottomSheetState.error);
    }
  }

  Future<void> load(WbBottomSheetAddFormModel form) async {
    try {
      emit(WbAddBottomSheetState.intital);
      emit(WbAddBottomSheetState.loading);
      emit(WbAddBottomSheetState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbAddBottomSheetState.error);
    }
  }

  Future<void> save(WbBottomSheetAddFormModel form) async {
    try {
      emit(WbAddBottomSheetState.intital);
      emit(WbAddBottomSheetState.loading);
      final qty = double.tryParse(form.controller.text);

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

      emit(WbAddBottomSheetState.save);
      emit(WbAddBottomSheetState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbAddBottomSheetState.error);
    }
  }
}

class WbBottomSheetAddForm extends Cubit<WbBottomSheetAddFormModel> {
  WbBottomSheetAddForm() : super(WbBottomSheetAddFormModel.empty());
}
