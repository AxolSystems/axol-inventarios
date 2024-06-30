import 'package:axol_inventarios/modules/module/model/module_model.dart';
import 'package:axol_inventarios/modules/module/model/set_module_drawer_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/set_module_form_model.dart';
import '../../repository/module_repo.dart';
import '../../view/set_module_drawer.dart';
import 'set_module_state.dart';

/// Lógica del negocio de la vista para la configuración módulos.
class SetModuleCubit extends Cubit<SetModuleState> {
  SetModuleCubit() : super(LoadedSetModuleState());

  /// Procesos realizados al iniciar el widget.
  Future<void> initLoad(SetModuleFormModel form) async {
    try {
      emit(InitialSetModuleState());
      emit(LoadingSetModuleState());

      form.modules = await ModuleRepo.fetchModuleList();

      emit(LoadedSetModuleState());
    } catch (e) {
      emit(InitialSetModuleState());
      emit(ErrorSetModuleState(error: e.toString()));
    }
  }

  /// Método de recarga de vista. Solo utilizado en caso
  /// de ser necesario actualizar estados desde otra clase.
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

  /// Lógica utilizada una vez se presiona el botón para editar un módulo.
  Future<void> edit(
      BuildContext context, SetModuleFormModel form, ModuleModel module) async {
    try {
      emit(InitialSetModuleState());
      emit(LoadingSetModuleState());
      showDialog(
        context: context,
        builder: (context) => SetModuleDrawer(
            module,
            theme: form.theme, action: EnumSetModuleAction.edit,),
      ).then((value) {
        if (value == true) {
          initLoad(form);
        }
      },);
      emit(LoadedSetModuleState());
    } catch (e) {
      emit(InitialSetModuleState());
      emit(ErrorSetModuleState(error: e.toString()));
    }
  }
}

/// Cubit que mantiene a la par los datos que cambian de la vista para editar módulos.
class SetModuleForm extends Cubit<SetModuleFormModel> {
  SetModuleForm() : super(SetModuleFormModel.empty());
}
