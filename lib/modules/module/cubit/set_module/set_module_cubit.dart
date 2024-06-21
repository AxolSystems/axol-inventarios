import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/set_module_form_model.dart';
import 'set_module_state.dart';

class SetModuleCubit extends Cubit<SetModuleState> {
  SetModuleCubit() : super(LoadedSetModuleState());

  Future<void> initLoad() async {
    try {
      emit(InitialSetModuleState());
      emit(LoadingSetModuleState());
      emit(LoadedSetModuleState());
    } catch (e) {
      emit(InitialSetModuleState());
      emit(ErrorSetModuleState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSetModuleState());
      emit(LoadingSetModuleState());
      emit(LoadedSetModuleState());
    } catch (e) {
      emit(InitialSetModuleState());
      emit(ErrorSetModuleState(error: e.toString()));
    }
  }
}

class SetModuleForm extends Cubit<SetModuleFormModel> {
  SetModuleForm() : super(SetModuleFormModel.empty());
}
