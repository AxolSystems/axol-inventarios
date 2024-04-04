import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/wb_bottomsheet_form_model.dart';

enum WbAddBottomSheetState {intital, loading, load, error}

class WbAddBottomSheetCubit extends Cubit<WbAddBottomSheetState> {
  WbAddBottomSheetCubit() : super(WbAddBottomSheetState.intital);

   Future<void> initLoad(WbBottomSheetFormModel form, String initValue) async {
    try {
      emit(WbAddBottomSheetState.intital);
      emit(WbAddBottomSheetState.loading);
      form.itemValue = initValue;
      emit(WbAddBottomSheetState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbAddBottomSheetState.error);
    }
  } 

  Future<void> load(WbBottomSheetFormModel form) async {
    try {
      emit(WbAddBottomSheetState.intital);
      emit(WbAddBottomSheetState.loading);
      emit(WbAddBottomSheetState.load);
    } catch (e) {
      form.errorMessage = e.toString();
      emit(WbAddBottomSheetState.error);
    }
  }
}

class WbBottomSheetForm extends Cubit<WbBottomSheetFormModel> {
  WbBottomSheetForm() : super(WbBottomSheetFormModel.empty());
}