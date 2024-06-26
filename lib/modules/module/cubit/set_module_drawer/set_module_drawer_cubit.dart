import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/module_model.dart';
import '../../model/set_module_drawer_form_model.dart';
import 'set_module_drawer_state.dart';

class SetModuleDrawerCubit extends Cubit<SetModuleDrawerState> {
  SetModuleDrawerCubit() : super(LoadedSetModuleDrawerState());

  Future<void> initLoad(SetModuleDrawerFormModel form, ModuleModel module) async {
    try {
      emit(InitialSetModuleDrawerState());
      emit(LoadingSetModuleDrawerState());

      form.ctrlName.text = module.name;
      form.ctrlIcon.text = module.icon.codePoint.toString();
      form.links = module.widgetLinks;

      emit(LoadedSetModuleDrawerState());
    } catch (e) {
      emit(InitialSetModuleDrawerState());
      emit(ErrorSetModuleDrawerState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSetModuleDrawerState());
      emit(LoadingSetModuleDrawerState());
      emit(LoadedSetModuleDrawerState());
    } catch (e) {
      emit(InitialSetModuleDrawerState());
      emit(ErrorSetModuleDrawerState(error: e.toString()));
    }
  }
}

class SetModuleDrawerForm extends Cubit<SetModuleDrawerFormModel> {
  SetModuleDrawerForm() : super(SetModuleDrawerFormModel.empty());
}