import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget_link/model/widgetlink_model.dart';
import '../../model/module_model.dart';
import '../../model/set_module_drawer_form_model.dart';
import 'set_module_drawer_state.dart';

/// Lógica del negocio del drawer para editar módulos.
class SetModuleDrawerCubit extends Cubit<SetModuleDrawerState> {
  SetModuleDrawerCubit() : super(LoadedSetModuleDrawerState());

  /// Realiza las preparaciones de las variables como el form para construir el
  /// widget de ajustes del módulo.
  Future<void> initLoad(
      SetModuleDrawerFormModel form, ModuleModel module) async {
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

  /// Actualiza el estado sin necesidad de pasar por ningún proceso.
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

  /// Actualiza lista de links del formulario del módulo según el valor recibido.
  Future<void> thenAddLink(dynamic value, SetModuleDrawerFormModel form) async {
    try {
      emit(InitialSetModuleDrawerState());
      emit(LoadingSetModuleDrawerState());
      if (value is WidgetLinkModel) {
        form.links.add(value);
      }
      emit(LoadedSetModuleDrawerState());
    } catch (e) {
      emit(InitialSetModuleDrawerState());
      emit(ErrorSetModuleDrawerState(error: e.toString()));
    }
  }

  Future<void> save(SetModuleDrawerFormModel form) async {
    try {
      emit(InitialSetModuleDrawerState());
      emit(LoadingSetModuleDrawerState());
      final bool isEqual;

      isEqual = SetModuleDrawerFormModel.compareForms(form);
      print(isEqual);
      print(form.initForm[SetModuleFormEnum.links]);

      emit(LoadedSetModuleDrawerState());
    } catch (e) {
      emit(InitialSetModuleDrawerState());
      emit(ErrorSetModuleDrawerState(error: e.toString()));
    }
  }
}

/// Cubit que mantiene en segundo plano los datos del drawer de
/// ajustes de módulos.
class SetModuleDrawerForm extends Cubit<SetModuleDrawerFormModel> {
  final ModuleModel module;

  SetModuleDrawerForm(this.module)
      : super(SetModuleDrawerFormModel.empty(module));
}
