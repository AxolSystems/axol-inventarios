import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../widget_link/model/widgetlink_model.dart';
import '../../model/module_model.dart';
import '../../model/set_module_drawer_form_model.dart';
import '../../repository/module_data_repo.dart';
import '../../repository/module_repo.dart';
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
      for (var link in module.widgetLinks) {
        form.links.add(link);
      }

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

  /// Actualiza en la base de datos el estado actual del formulario.
  Future<void> save(SetModuleDrawerFormModel form, ModuleModel module,
      EnumSetModuleAction action) async {
    try {
      emit(InitialSetModuleDrawerState());
      emit(SavingSetModuleDrawerState());
      ModuleModel cModule;
      IconData icon;

      if (int.tryParse(form.ctrlIcon.text) != null) {
        icon = IconsRepo.getIcon(int.parse(form.ctrlIcon.text));
      } else {
        icon = module.icon;
      }

      cModule = ModuleModel(
        name: form.ctrlName.text,
        id: module.id,
        icon: icon,
        widgetLinks: form.links,
        permissions: module.permissions,
      );

      if (action == EnumSetModuleAction.add) {
        cModule = ModuleModel.setId(module: cModule, newId: const Uuid().v4());
        await ModuleRepo.insert(cModule);
      } else if (action == EnumSetModuleAction.edit) {
        await ModuleRepo.update(cModule);
      }
      
      emit(SavedSetModuleDrawerState());
    } catch (e) {
      emit(InitialSetModuleDrawerState());
      emit(ErrorSetModuleDrawerState(error: e.toString()));
    }
  }

  /// Acciones al seleccionar un opción del popupMenu de la lista de
  /// widgetLinks. 0: Eliminar.
  Future<void> onSelectPopupMenu(
      int value, SetModuleDrawerFormModel form, int index) async {
    try {
      emit(InitialSetModuleDrawerState());
      emit(LoadingSetModuleDrawerState());
      if (value == 0) {
        form.links.removeAt(index);
      }
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
