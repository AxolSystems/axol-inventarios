import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/wb_bottomsheet_find_form_model.dart';

enum WbBottomSheetFindState { intital, loading, load, error, save }

class WbBottomSheetFindCubit extends Cubit<WbBottomSheetFindState> {
  WbBottomSheetFindCubit() : super(WbBottomSheetFindState.intital);

  Future<void> initLoad(
      WbButtonsheetFindFormModel form, String initValue) async {
    try {
      emit(WbBottomSheetFindState.intital);
      emit(WbBottomSheetFindState.loading);
      //form.itemValue = initValue;
      emit(WbBottomSheetFindState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbBottomSheetFindState.error);
    }
  }

  Future<void> load(WbBottomSheetAddFormModel form) async {
    try {
      emit(WbBottomSheetFindState.intital);
      emit(WbBottomSheetFindState.loading);
      emit(WbBottomSheetFindState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbBottomSheetFindState.error);
    }
  }

  Future<void> save(WbBottomSheetAddFormModel form) async {
    try {
      emit(WbBottomSheetFindState.intital);
      emit(WbBottomSheetFindState.loading);
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

      emit(WbBottomSheetFindState.save);
      emit(WbBottomSheetFindState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbBottomSheetFindState.error);
    }
  }
}

class WbBottomSheetAddForm extends Cubit<WbBottomSheetAddFormModel> {
  WbBottomSheetAddForm() : super(WbBottomSheetAddFormModel.empty());
}