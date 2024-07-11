import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../block/model/property_model.dart';
import '../../../../object/model/object_model.dart';
import '../../../../object/repository/object_repo.dart';
import '../../../../widget_link/model/widgetlink_model.dart';
import '../../model/row_details_form_model.dart';
import 'row_details_state.dart';

/// Cubit con lógica del negocio de drawer de detalles
/// del objeto recibido.
class RowDetailsCubit extends Cubit<RowDetailsState> {
  RowDetailsCubit() : super(InitialRowDetailsState());

  /// Recarga los estados para mostrar un cambio en los parámetros
  /// mutables. Util si se requiere recargar la pantalla desde fuera
  /// del cubit.
  Future<void> load() async {
    try {
      emit(InitialRowDetailsState());
      emit(LoadingRowDetailsState());

      emit(LoadedRowDetailsState());
    } catch (e) {
      emit(InitialRowDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Carga el estado inicial de los parámetros de form.
  Future<void> initLoad(RowDetailsFormModel form, WidgetLinkModel link,
      ObjectModel object) async {
    try {
      emit(InitialRowDetailsState());
      emit(LoadingRowDetailsState());

      form.object = ObjectModel(
          id: object.id, map: object.map, createAt: object.createAt);
      for (PropertyModel prop in link.block.propertyList) {
        final String cell;
        if (form.object.map[prop.key] is String) {
          cell = form.object.map[prop.key] as String;
        } else {
          cell = '';
        }
        form.controllers[prop.key] = TextEditingController(text: cell);
      }

      emit(LoadedRowDetailsState());
    } catch (e) {
      emit(InitialRowDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Cambia al estado de edición.
  Future<void> edit(RowDetailsFormModel form) async {
    try {
      emit(InitialRowDetailsState());
      emit(LoadingRowDetailsState());
      form.edit = !form.edit;
      emit(LoadedRowDetailsState());
    } catch (e) {
      emit(InitialRowDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Proceso para guardar los cambios realizados en el objeto.
  Future<void> save(RowDetailsFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialRowDetailsState());
      emit(SavingRowDetailsState());
      ObjectModel object;
      Map<String, dynamic> map = {};
      TextEditingController controller;

      for (String key in form.object.map.keys) {
        controller = form.controllers[key] ?? TextEditingController();
        map[key] = controller.text;
      }
      object = ObjectModel(
          createAt: form.object.createAt, id: form.object.id, map: map);

      await ObjectRepo.updateObject(object, link);
      form.object = object;

      emit(SavedRowDetailsState());
      emit(LoadedRowDetailsState());
    } catch (e) {
      emit(InitialRowDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Función para eliminar objeto actual en form.
  Future<void> delete(RowDetailsFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialRowDetailsState());
      emit(DeletingRowDetailsState());

      await ObjectRepo.deleteObject(form.object, link);

      emit(DeletedRowDetailsState());
      emit(LoadedRowDetailsState());
    } catch (e) {
      emit(InitialRowDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }
}

/// Cubit que mantiene modelo de datos del formulario en segundo planto
/// respecto al cambio de estados.
class RowDetailsForm extends Cubit<RowDetailsFormModel> {
  RowDetailsForm() : super(RowDetailsFormModel.empty());
}
