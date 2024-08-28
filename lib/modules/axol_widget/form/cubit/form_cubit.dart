import 'package:axol_inventarios/modules/axol_widget/form/model/form_form_model.dart';
import 'package:axol_inventarios/modules/entity/model/entity_model.dart';
import 'package:axol_inventarios/modules/object/model/atomic_object_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../entity/model/property_model.dart';
import '../../../object/model/object_model.dart';
import '../../../object/repository/object_repo.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../../../widget_link/repository/widgetlink_repo.dart';
import 'form_state.dart';

class FormCubit extends Cubit<FormDrawerState> {
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

  Future<void> initLoad(FormFormModel form, EntityModel entity,
      [List<PropertyModel>? atmPropertyList]) async {
    try {
      emit(InitialFormState());
      emit(LoadingFormState());
      final List<PropertyModel> propertyList;

      if (atmPropertyList != null) {
        propertyList = atmPropertyList;
      } else {
        propertyList = entity.propertyList;
      }

      for (PropertyModel prop in propertyList) {
        if (prop.propertyType == Prop.text) {
          form.fields.add(TextFieldModel(
            ctrlText: TextEditingController(),
            property: prop,
          ));
        } else if (prop.propertyType == Prop.int ||
            prop.propertyType == Prop.double) {
          form.fields.add(NumberFieldModel(
            ctrlNum: TextEditingController(),
            property: prop,
          ));
        } else if (prop.propertyType == Prop.bool) {
          form.fields.add(BooleanFieldModel(
            value: false,
            property: prop,
          ));
        } else if (prop.propertyType == Prop.time) {
          form.fields.add(DateFieldModel(
            dateTime: DateTime.now(),
            property: prop,
          ));
        } else if (prop.propertyType == Prop.referenceObject) {
          final List<WidgetLinkModel> refLinks =
              await WidgetLinkRepo.fetchWidgetLik(
                  [prop.dynamicValues[PropertyModel.dvRefLink] ?? '']);
          final ReferenceObjectModel refObjInit = ReferenceObjectModel(
            referenceObject: ObjectModel.empty(),
            idPropertyView: prop.dynamicValues[ReferenceObjectModel.property],
            referenceLink: refLinks.first,
          );
          form.fields.add(ReferenceObjectFieldModel(
            refObj: refObjInit,
            property: prop,
          ));
        } else if (prop.propertyType == Prop.atomicObject) {
          form.fields.add(AtmObjFieldModel(
            atomicObject: AtomicObjectModel.empty(),
            property: prop,
          ));
        }
      }

      emit(LoadedFormState());
    } catch (e) {
      emit(InitialFormState());
      emit(ErrorFormState(error: e.toString()));
    }
  }

  Future<void> save(FormFormModel form, WidgetLinkModel link,
      [List<PropertyModel>? atmPropertyList]) async {
    try {
      emit(InitialFormState());
      emit(SavingFormState());
      final List<PropertyModel> propertyList;
      ObjectModel object;
      Map<String, dynamic> map = {};
      int i;

      if (atmPropertyList != null) {
        propertyList = atmPropertyList;
      } else {
        propertyList = link.entity.propertyList;
      }

      for (PropertyModel prop in propertyList) {
        i = form.fields.indexWhere((x) => x.property.key == prop.key);
        if (i > -1) {
          if (form.fields[i] is TextFieldModel) {
            final TextFieldModel textField = form.fields[i] as TextFieldModel;
            map[prop.key] = textField.ctrlText.text;
          } else if (form.fields[i] is NumberFieldModel) {
            final NumberFieldModel numberField =
                form.fields[i] as NumberFieldModel;
            map[prop.key] = double.parse(numberField.ctrlNum.text);
          } else if (form.fields[i] is BooleanFieldModel) {
            final BooleanFieldModel booleanField =
                form.fields[i] as BooleanFieldModel;
            map[prop.key] = booleanField.value;
          } else if (form.fields[i] is DateFieldModel) {
            final DateFieldModel dateField = form.fields[i] as DateFieldModel;
            map[prop.key] = dateField.dateTime.millisecondsSinceEpoch;
          } else if (form.fields[i] is ReferenceObjectFieldModel) {
            final ReferenceObjectFieldModel refObjField =
                form.fields[i] as ReferenceObjectFieldModel;
            map[prop.key] = refObjField.refObj.referenceObject.id;
          } else if (form.fields[i] is AtmObjFieldModel) {
            final AtmObjFieldModel atmObjField =
                form.fields[i] as AtmObjFieldModel;
            map[prop.key] = {
              AtomicObjectModel.tId: atmObjField.atomicObject.id,
              AtomicObjectModel.tObject: atmObjField.atomicObject.values,
            };
          } else {
            map[prop.key] = null;
          }
        } else {
          map[prop.key] = null;
        }
      }

      object = ObjectModel(
        id: const Uuid().v4(),
        map: map,
        createAt: DateTime.now(),
      );
      if (atmPropertyList != null) {
      } else {
        await ObjectRepo.insert(object, link);
      }

      emit(SavedFormState(object: object));
      emit(LoadedFormState());
    } catch (e) {
      emit(InitialFormState());
      emit(ErrorFormState(error: e.toString()));
    }
  }

  Future<void> changeCheckbox(
      FormFormModel form, bool? value, int index) async {
    try {
      emit(InitialFormState());
      emit(LoadingFormState());
      if (value != null) {
        final BooleanFieldModel booleanField = BooleanFieldModel(
            value: value, property: form.fields[index].property);
        form.fields[index] = booleanField;
      }
      emit(LoadedFormState());
    } catch (e) {
      emit(InitialFormState());
      emit(ErrorFormState(error: e.toString()));
    }
  }

  Future<void> thenDateTimePick(
      FormFormModel form, int index, DateTime dateTime) async {
    try {
      emit(InitialFormState());
      emit(LoadingFormState());
      final DateFieldModel dateField = form.fields[index] as DateFieldModel;
      form.fields[index] =
          DateFieldModel(dateTime: dateTime, property: dateField.property);
      emit(LoadedFormState());
    } catch (e) {
      emit(InitialFormState());
      emit(ErrorFormState(error: e.toString()));
    }
  }

  Future<void> thenAtmObj(
      FormFormModel form, int index, ObjectModel object) async {
    try {
      emit(InitialFormState());
      emit(LoadingFormState());
      final AtmObjFieldModel atmObjField =
          form.fields[index] as AtmObjFieldModel;
      form.fields[index] = AtmObjFieldModel(
          atomicObject: AtomicObjectModel(id: object.id, values: object.map),
          property: atmObjField.property);
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
