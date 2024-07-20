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
        final String cellText;
        final bool cellBool;
        final DateTime cellTime;
        if (form.object.map[prop.key] is String &&
            prop.propertyType == Prop.text) {
          cellText = form.object.map[prop.key] as String;
          form.controllers[prop.key] = RDTextEditingController(
              controller: TextEditingController(text: cellText));
        } else if ((form.object.map[prop.key] is int ||
                form.object.map[prop.key] is double) &&
            (prop.propertyType == Prop.int ||
                prop.propertyType == Prop.double)) {
          cellText = form.object.map[prop.key].toString();
          form.controllers[prop.key] = RDTextEditingController(
              controller: TextEditingController(text: cellText));
        } else if (form.object.map[prop.key] is bool &&
            prop.propertyType == Prop.bool) {
          cellBool = form.object.map[prop.key];
          form.controllers[prop.key] = RDBoolController(controller: cellBool);
        } else if (form.object.map[prop.key] is int &&
            prop.propertyType == Prop.time) {
          cellTime = form.object.map[prop.key];
          form.controllers[prop.key] = RDDateController(controller: cellTime);
        }
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
      PropertyModel property;

      for (String key in form.object.map.keys) {
        final RDTextEditingController textController;
        final RDBoolController boolController;
        final RDDateController timeController;

        if (form.controllers[key] is RDTextEditingController) {
          textController = form.controllers[key] as RDTextEditingController;
        } else {
          textController = RDTextEditingController.empty();
        }

        if (form.controllers[key] is RDBoolController) {
          boolController = form.controllers[key] as RDBoolController;
        } else {
          boolController = RDBoolController.init();
        }

        if (form.controllers[key] is RDDateController) {
          timeController = form.controllers[key] as RDDateController;
        } else {
          timeController = form.controllers[key] as RDDateController;
        }

        property = link.block.propertyList.firstWhere((x) => x.key == key);

        if (form.controllers[key] is RDTextEditingController &&
            property.propertyType == Prop.text) {
          map[key] = textController.controller.text;
        } else if (form.controllers[key] is RDTextEditingController &&
            (property.propertyType == Prop.int ||
                property.propertyType == Prop.double)) {
          map[key] = double.parse(textController.controller.text);
        } else if (form.controllers[key] is RDDateController &&
            property.propertyType == Prop.time) {
          map[key] = timeController.controller.millisecondsSinceEpoch;
        } else if (form.controllers[key] is RDBoolController &&
            property.propertyType == Prop.bool) {
          map[key] = boolController.controller;
        }
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
