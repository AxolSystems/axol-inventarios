import 'package:axol_inventarios/modules/formula/repository/formula_function.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../array/model/array_model.dart';
import '../../../array/repository/array_repo.dart';
import '../../../entity/model/property_model.dart';
import '../../../object/model/atomic_object_model.dart';
import '../../../object/model/object_model.dart';
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
      ObjectModel object, ReferenceObjectModel? referenceObject,
      [List<PropertyModel>? propsAtmObj]) async {
    try {
      emit(InitialObjectDetailsState());
      emit(LoadingObjectDetailsState());
      final List<PropertyModel> propList;
      Map<String, dynamic> objectMap = {};

      for (String key in object.map.keys) {
        objectMap[key] = object.map[key];
      }

      if (referenceObject != null) {
        propList = referenceObject.referenceLink.entity.propertyList;
      } else {
        propList = propsAtmObj ?? link.entity.propertyList;
      }

      form.object =
          ObjectModel(id: object.id, map: objectMap, createAt: object.createAt);
      for (PropertyModel prop in propList) {
        final String cellText;
        final bool cellBool;
        final DateTime? cellTime;
        final ReferenceObjectModel cellRefObj;
        final AtomicObjectModel cellAtmObj;
        final ArrayModel cellArray;
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
          cellTime = form.object.map[prop.key] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(form.object.map[prop.key]);
          form.controllers[prop.key] = RDDateController(controller: cellTime);
        } else if (prop.propertyType == Prop.referenceObject) {
          cellRefObj = form.object.map[prop.key] ??
              ReferenceObjectModel(
                  idPropertyView:
                      prop.dynamicValues[ReferenceObjectModel.property],
                  referenceLink: prop.dynamicValues[PropertyModel.dvRefLink],
                  referenceObject: ObjectModel.empty());
          form.controllers[prop.key] = RDReferenceObject(
              refObject: cellRefObj,
              oldIdRefObject: cellRefObj.referenceObject.id);
        } else if (prop.propertyType == Prop.atomicObject) {
          cellAtmObj =
              form.object.map[prop.key] ?? AtomicObjectModel.idInit(prop.key);
          form.controllers[prop.key] = RDAtomicObject(atmObject: cellAtmObj);
        } else if (prop.propertyType == Prop.array) {
          if (form.object.map[prop.key] == null) {
            final String idArray = prop.dynamicValues[PropertyModel.dvIdArray];
            final List<String> list = await ArrayRepo.postgresFetchArrayById(idArray);
            //await ArrayRepo.fetchArrayById(idArray);
            if (list.isEmpty) {
              list.add('');
            }
            cellArray = ArrayModel(id: idArray, list: list, value: '');
            form.object.map[prop.key] = cellArray;
          } else {
            cellArray = form.object.map[prop.key];
          }
          form.controllers[prop.key] = RDArray(array: cellArray);
        } else if (prop.propertyType == Prop.formula) {
          double value = 0;
          value = await FormulaFunction.devExpressions(
              prop.dynamicValues[PropertyModel.dvFormula], form.object, link);
          form.controllers[prop.key] = RDFormula(
              formula: prop.dynamicValues[PropertyModel.dvFormula],
              value: '$value',
              error: '');
        }
      }

      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Actualiza objeto de form.
  Future<void> updateObjectForm(
      ObjectDetailsFormModel form, List<PropertyModel> propertyList) async {
    try {
      emit(InitialObjectDetailsState());
      emit(LoadingObjectDetailsState());
      Map<String, dynamic> map = {};
      PropertyModel property;

      for (String key in form.object.map.keys) {
        final RDTextEditingController textController;
        final RDBoolController boolController;
        final RDDateController dateController;
        final RDReferenceObject refObjController;
        final RDAtomicObject atmObjController;
        final RDArray arrayController;

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
          refObjController = RDReferenceObject.empty();
        }

        if (form.controllers[key] is RDAtomicObject) {
          atmObjController = form.controllers[key] as RDAtomicObject;
        } else {
          atmObjController = RDAtomicObject.empty(key);
        }

        if (form.controllers[key] is RDArray) {
          arrayController = form.controllers[key] as RDArray;
        } else {
          arrayController = RDArray.empty();
        }

        property = propertyList.firstWhere((x) => x.key == key);

        if (form.controllers[key] is RDTextEditingController &&
            property.propertyType == Prop.text) {
          map[key] = textController.controller.text;
          form.object.map[key] = textController.controller.text;
        } else if (form.controllers[key] is RDTextEditingController &&
            (property.propertyType == Prop.int ||
                property.propertyType == Prop.double)) {
          map[key] = double.tryParse(textController.controller.text) ?? 0;
          //form.object.map[key] = double.parse(textController.controller.text);
        } else if (form.controllers[key] is RDDateController &&
            property.propertyType == Prop.time) {
          map[key] = dateController.controller?.millisecondsSinceEpoch;
          form.object.map[key] =
              dateController.controller?.millisecondsSinceEpoch;
        } else if (form.controllers[key] is RDBoolController &&
            property.propertyType == Prop.bool) {
          map[key] = boolController.controller;
          form.object.map[key] = boolController.controller;
        } else if (form.controllers[key] is RDReferenceObject &&
            property.propertyType == Prop.referenceObject) {
          map[key] = refObjController;
        } else if (form.controllers[key] is RDAtomicObject &&
            property.propertyType == Prop.atomicObject) {
          map[key] = atmObjController;
          form.object.map[key] = atmObjController.atmObject;
        } else if (form.controllers[key] is RDArray &&
            property.propertyType == Prop.array) {
          if (arrayController.array.value == '') {
            final ArrayModel array = form.object.map[property.key];
            map[key] = array.list.first;
            form.object.map[property.key] = array.setValue(map[key]);
          } else {
            map[key] = arrayController.array;
          }
        }
      }
      form.object = ObjectModel(
          createAt: form.object.createAt, id: form.object.id, map: map);

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
  Future<void> save(
    ObjectDetailsFormModel form,
    WidgetLinkModel link,
    ObjectModel initObject,
  ) async {
    try {
      emit(InitialObjectDetailsState());
      emit(SavingObjectDetailsState());
      ObjectModel object;
      Map<String, dynamic> map = {};
      PropertyModel property;

      for (String key in form.object.map.keys) {
        final RDTextEditingController textController;
        final RDBoolController boolController;
        final RDDateController dateController;
        final RDReferenceObject refObjController;
        final RDAtomicObject atmObjController;
        final RDArray arrayController;

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
          refObjController = RDReferenceObject.empty();
        }

        if (form.controllers[key] is RDAtomicObject) {
          atmObjController = form.controllers[key] as RDAtomicObject;
        } else {
          atmObjController = RDAtomicObject.empty(key);
        }

        if (form.controllers[key] is RDArray) {
          arrayController = form.controllers[key] as RDArray;
        } else {
          arrayController = RDArray.empty();
        }

        property = link.entity.propertyList.firstWhere((x) => x.key == key);

        if (form.controllers[key] is RDTextEditingController &&
            property.propertyType == Prop.text) {
          map[key] = textController.controller.text;
          form.object.map[key] = textController.controller.text;
        } else if (form.controllers[key] is RDTextEditingController &&
            (property.propertyType == Prop.int ||
                property.propertyType == Prop.double)) {
          map[key] = double.tryParse(textController.controller.text) ?? 0;
          form.object.map[key] = double.tryParse(textController.controller.text) ?? 0;
        } else if (form.controllers[key] is RDDateController &&
            property.propertyType == Prop.time) {
          map[key] = dateController.controller?.millisecondsSinceEpoch;
          form.object.map[key] =
              dateController.controller?.millisecondsSinceEpoch;
        } else if (form.controllers[key] is RDBoolController &&
            property.propertyType == Prop.bool) {
          map[key] = boolController.controller;
          form.object.map[key] = boolController.controller;
        } else if (form.controllers[key] is RDReferenceObject &&
            property.propertyType == Prop.referenceObject) {
          map[key] = refObjController.refObject.referenceObject.id;
          form.object.map[key] = ReferenceObjectModel.setRefObj(
              form.object.map[key], refObjController.refObject.referenceObject);
        } else if (form.controllers[key] is RDAtomicObject &&
            property.propertyType == Prop.atomicObject) {
          map[key] = {
            AtomicObjectModel.tId: atmObjController.atmObject.id,
            AtomicObjectModel.tObject: atmObjController.atmObject.values,
          };
          form.object.map[key] = atmObjController.atmObject;
        } else if (form.controllers[key] is RDArray &&
            property.propertyType == Prop.array) {
          if (arrayController.array.value == '') {
            final ArrayModel array = form.object.map[property.key];
            map[key] = array.list.first;
            form.object.map[property.key] = array.setValue(map[key]);
          } else {
            map[key] = arrayController.array.value;
          }
        }
      }

      /// Volver genérico.
      bool isError = false;
      for (PropertyModel prop in link.entity.propertyList) {
        if (prop.propertyType == Prop.formula &&
            prop.dynamicValues[PropertyModel.dvFormula].contains('[query')) {
          final double value = await FormulaFunction.devExpressions(
              prop.dynamicValues[PropertyModel.dvFormula], form.object, link);
          final double total = value -
              initObject.map['c13'] -
              initObject.map['c14'] +
              map['c13'] +
              map['c14'];
          if (total > map['c12']) {
            isError = true;
            emit(const ErrorRowDetailsState(
                error: 'Cantidad total supera a cantidad de trabajo.'));
            return;
          }
        }
      }

      ///--------------------
      if (!isError) {
        object = ObjectModel(
            createAt: form.object.createAt, id: form.object.id, map: map);

        await ObjectRepo.update(object, link);
        form.isEdited = true;

        emit(SavedObjectDetailsState());
      }

      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  /// Proceso para guardar los cambios realizados en objeto atómico.
  Future<void> saveAtmObj(
      ObjectDetailsFormModel form, List<PropertyModel> propsAtmObj) async {
    try {
      emit(InitialObjectDetailsState());
      emit(SavingObjectDetailsState());
      Map<String, dynamic> map = {};

      for (PropertyModel prop in propsAtmObj) {
        final RDTextEditingController textController;
        final RDBoolController boolController;
        final RDDateController dateController;
        final RDReferenceObject refObjController;
        final RDAtomicObject atmObjController;

        if (form.controllers[prop.key] is RDTextEditingController) {
          textController =
              form.controllers[prop.key] as RDTextEditingController;
        } else {
          textController = RDTextEditingController.empty();
        }

        if (form.controllers[prop.key] is RDBoolController) {
          boolController = form.controllers[prop.key] as RDBoolController;
        } else {
          boolController = RDBoolController.init();
        }

        if (form.controllers[prop.key] is RDDateController) {
          dateController = form.controllers[prop.key] as RDDateController;
        } else {
          dateController = RDDateController(controller: DateTime.now());
        }

        if (form.controllers[prop.key] is RDReferenceObject) {
          refObjController = form.controllers[prop.key] as RDReferenceObject;
        } else {
          refObjController = RDReferenceObject.empty();
        }

        if (form.controllers[prop.key] is RDAtomicObject) {
          atmObjController = form.controllers[prop.key] as RDAtomicObject;
        } else {
          atmObjController = RDAtomicObject.empty(prop.key);
        }

        if (form.controllers[prop.key] is RDTextEditingController &&
            prop.propertyType == Prop.text) {
          map[prop.key] = textController.controller.text;
          form.object.map[prop.key] = textController.controller.text;
        } else if (form.controllers[prop.key] is RDTextEditingController &&
            (prop.propertyType == Prop.int ||
                prop.propertyType == Prop.double)) {
          map[prop.key] = double.parse(textController.controller.text);
          form.object.map[prop.key] =
              double.parse(textController.controller.text);
        } else if (form.controllers[prop.key] is RDDateController &&
            prop.propertyType == Prop.time) {
          map[prop.key] = dateController.controller?.millisecondsSinceEpoch;
          form.object.map[prop.key] =
              dateController.controller?.millisecondsSinceEpoch;
        } else if (form.controllers[prop.key] is RDBoolController &&
            prop.propertyType == Prop.bool) {
          map[prop.key] = boolController.controller;
          form.object.map[prop.key] = boolController.controller;
        } else if (form.controllers[prop.key] is RDReferenceObject &&
            prop.propertyType == Prop.referenceObject) {
          map[prop.key] = refObjController.refObject.referenceObject.id;
          form.object.map[prop.key] = ReferenceObjectModel.setRefObj(
              form.object.map[prop.key],
              refObjController.refObject.referenceObject);
        } else if (form.controllers[prop.key] is RDAtomicObject &&
            prop.propertyType == Prop.atomicObject) {
          map[prop.key] = {
            AtomicObjectModel.tId: atmObjController.atmObject.id,
            AtomicObjectModel.tObject: atmObjController.atmObject.values,
          };
          form.object.map[prop.key] = atmObjController.atmObject;
        }
      }

      form.isEdited = true;
      if (form.object.id == '') {
        form.object = ObjectModel.setId(form.object, const Uuid().v4());
      }

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
      {required DateTime? dateTime,
      required ObjectDetailsFormModel form,
      required PropertyModel prop,
      required int index}) async {
    try {
      emit(InitialObjectDetailsState());
      emit(LoadingObjectDetailsState());
      form.controllers[prop.key] = RDDateController(controller: dateTime);
      emit(LoadedObjectDetailsState());
    } catch (e) {
      emit(InitialObjectDetailsState());
      emit(ErrorRowDetailsState(error: e.toString()));
    }
  }

  Future<void> changeArray({
    required ObjectDetailsFormModel form,
    required PropertyModel prop,
    required String value,
    required ArrayModel array,
    required int index,
  }) async {
    try {
      emit(InitialObjectDetailsState());
      emit(DeletingObjectDetailsState());
      form.controllers[prop.key] = RDArray(
          array: ArrayModel(id: array.id, list: array.list, value: value));
      form.object.map[prop.key] =
          ArrayModel(id: array.id, list: array.list, value: value);

      emit(DeletedObjectDetailsState());
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
