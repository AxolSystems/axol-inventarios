import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/model/property_model.dart';
import '../../../object/model/object_model.dart';
import '../../../object/model/object_relation.dart';
import '../../../object/repository/object_repo.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../model/object_details_form_model.dart';
import 'object_details_state.dart';

/// Cubit con lógica del negocio de drawer de detalles
/// del objeto recibido.
class ObjectDetailsCubit extends Cubit<ObjectDetailsState> {
  ObjectDetailsCubit() : super(InitialObjectDetailsState());

  /// Recarga los estados para mostrar un cambio en los parámetros
  /// mutables. Util si se requiere recargar la pantalla desde fuera
  /// del cubit.
  Future<void> load() async {
    try {
      emit(InitialObjectDetailsState());
      emit(LoadingObjectDetailsState());

      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Carga el estado inicial de los parámetros de form.
  Future<void> initLoad(ObjectDetailsFormModel form, WidgetLinkModel link,
      ObjectModel object, ReferenceObjectModel? referenceObject) async {
    try {
      emit(InitialObjectDetailsState());
      emit(LoadingObjectDetailsState());
      final List<PropertyModel> propList;

      if (referenceObject != null) {
        propList = referenceObject.referenceLink.entity.propertyList;
      } else {
        propList = link.entity.propertyList;
      }

      form.object = ObjectModel(
          id: object.id, map: object.map, createAt: object.createAt);
      for (PropertyModel prop in propList) {
        final String cellText;
        final bool cellBool;
        final DateTime cellTime;
        final ReferenceObjectModel cellRefObj;
        if ((form.object.map[prop.key] is String ||
                form.object.map[prop.key] == null) &&
            prop.propertyType == Prop.text) {
          cellText = form.object.map[prop.key] ?? '';
          form.controllers[prop.key] = RDTextEditingController(
              controller: TextEditingController(text: cellText));
        } else if ((form.object.map[prop.key] is int ||
                form.object.map[prop.key] is double ||
                form.object.map[prop.key] == null) &&
            (prop.propertyType == Prop.int ||
                prop.propertyType == Prop.double)) {
          cellText = '${form.object.map[prop.key] ?? ''}';
          form.controllers[prop.key] = RDTextEditingController(
              controller: TextEditingController(text: cellText));
        } else if ((form.object.map[prop.key] is bool ||
                form.object.map[prop.key] == null) &&
            prop.propertyType == Prop.bool) {
          cellBool = form.object.map[prop.key] ?? false;
          form.controllers[prop.key] = RDBoolController(controller: cellBool);
        } else if ((form.object.map[prop.key] is int ||
                form.object.map[prop.key] == null) &&
            prop.propertyType == Prop.time) {
          cellTime = DateTime.fromMillisecondsSinceEpoch(
              form.object.map[prop.key] ?? 0);
          form.controllers[prop.key] = RDDateController(controller: cellTime);
        } else if (prop.propertyType == Prop.referenceObject) {
          cellRefObj =
              form.object.map[prop.key] ?? ReferenceObjectModel.empty();
          form.controllers[prop.key] = RDReferenceObject(refObject: cellRefObj, oldIdRefObject: cellRefObj.referenceObject.id);
        }
      }

      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Cambia al estado de edición.
  Future<void> edit(ObjectDetailsFormModel form) async {
    try {
      emit(InitialObjectDetailsState());
      emit(LoadingObjectDetailsState());
      form.edit = !form.edit;
      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Proceso para guardar los cambios realizados en el objeto.
  Future<void> save(ObjectDetailsFormModel form, WidgetLinkModel link,) async {
    try {
      emit(InitialObjectDetailsState());
      emit(SavingObjectDetailsState());
      ObjectModel object;
      Map<String, dynamic> map = {};
      PropertyModel property;
      List<ObjectRelation> objRelationList = [];

      for (String key in form.object.map.keys) {
        final RDTextEditingController textController;
        final RDBoolController boolController;
        final RDDateController dateController;
        final RDReferenceObject refObjController;

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
          dateController = form.controllers[key] as RDDateController;
        } else {
          dateController = RDDateController(controller: DateTime.now());
        }

        if (form.controllers[key] is RDReferenceObject) {
          refObjController = form.controllers[key] as RDReferenceObject;
        } else {
          refObjController =
              RDReferenceObject.empty();
        }

        property = link.entity.propertyList.firstWhere((x) => x.key == key);

        if (form.controllers[key] is RDTextEditingController &&
            property.propertyType == Prop.text) {
          map[key] = textController.controller.text;
          form.object.map[key] = textController.controller.text;
        } else if (form.controllers[key] is RDTextEditingController &&
            (property.propertyType == Prop.int ||
                property.propertyType == Prop.double)) {
          map[key] = double.parse(textController.controller.text);
          form.object.map[key] = double.parse(textController.controller.text);
        } else if (form.controllers[key] is RDDateController &&
            property.propertyType == Prop.time) {
          map[key] = dateController.controller.millisecondsSinceEpoch;
          form.object.map[key] =
              dateController.controller.millisecondsSinceEpoch;
        } else if (form.controllers[key] is RDBoolController &&
            property.propertyType == Prop.bool) {
          map[key] = boolController.controller;
          form.object.map[key] = boolController.controller;
        } else if (form.controllers[key] is RDReferenceObject &&
            property.propertyType == Prop.referenceObject) {
          map[key] = refObjController.refObject.referenceObject.id;
          form.object.map[key] = ReferenceObjectModel.setRefObj(
              form.object.map[key], refObjController.refObject.referenceObject);
          objRelationList.add(
            ObjectRelation(
              idChildObject: form.object.id,
              newIdParentObject: refObjController.refObject.referenceObject.id,
              oldIdParentObject: refObjController.oldIdRefObject,
            ),
          );
        }
      }

      object = ObjectModel(
          createAt: form.object.createAt, id: form.object.id, map: map);

      await ObjectRepo.update(object, link);
      form.isEdited = true;

      emit(SavedObjectDetailsState());
      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Función para eliminar objeto actual en form.
  Future<void> delete(ObjectDetailsFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialObjectDetailsState());
      emit(DeletingObjectDetailsState());

      await ObjectRepo.delete(form.object, link);
      form.isEdited;

      emit(DeletedObjectDetailsState());
      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  Future<void> thenDateTimePick(
      {DateTime? date,
      TimeOfDay? time,
      required ObjectDetailsFormModel form,
      required PropertyModel prop}) async {
    try {
      emit(InitialObjectDetailsState());
      emit(LoadingObjectDetailsState());
      final RDDateController dateController =
          form.controllers[prop.key] as RDDateController;
      final DateTime dateTime = dateController.controller;
      if (date != null) {
        form.controllers[prop.key] = RDDateController(
            controller: DateTime(
          date.year,
          date.month,
          date.day,
          dateTime.hour,
          dateTime.minute,
        ));
      } else if (time != null) {
        form.controllers[prop.key] = RDDateController(
            controller: DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          time.hour,
          time.minute,
        ));
      }
      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }
}

/// Cubit que mantiene modelo de datos del formulario en segundo planto
/// respecto al cambio de estados.
class RowDetailsForm extends Cubit<ObjectDetailsFormModel> {
  RowDetailsForm() : super(ObjectDetailsFormModel.empty());
}
