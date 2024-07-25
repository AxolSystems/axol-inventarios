import 'package:axol_inventarios/modules/axol_widget/form/model/form_form_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'form_state.dart';

class FormCubit extends Cubit<FormState> {
  FormCubit() : super(InitialFormState());

  Future<void> load() async {
    try {
      emit(InitialFormState());
      emit(LoadingFormState());

      emit(LoadedFormState());
    } catch (e) {
      emit(InitialFormState());
      emit(ErrorFormState(error: e.toString()));
    }
  }

  Future<void> initLoad(FormFormModel form) async {
    try {
      emit(InitialFormState());
      emit(LoadingFormState());

      emit(LoadedFormState());
    } catch (e) {
      emit(InitialFormState());
      emit(ErrorFormState(error: e.toString()));
    }
  }
}

class FormForm extends Cubit<FormFormModel> {
  FormForm() : super(FormFormModel.empty());
}
