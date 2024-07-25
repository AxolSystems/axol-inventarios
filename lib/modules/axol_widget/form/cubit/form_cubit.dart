import 'package:axol_inventarios/modules/axol_widget/form/model/form_form_model.dart';
import 'package:axol_inventarios/modules/entity/model/entity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/model/property_model.dart';
import '../../../object/model/object_model.dart';
import '../../../widget_link/model/widgetlink_model.dart';
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

  Future<void> initLoad(FormFormModel form, EntityModel entity) async {
    try {
      emit(InitialFormState());
      emit(LoadingFormState());

      for (PropertyModel prop in entity.propertyList) {
        if (prop.propertyType == Prop.text) {
          form.fields.add(TextFieldModel(
            ctrlText: TextEditingController(),
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

  Future<void> save(FormFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialFormState());
      emit(LoadingFormState());
      ObjectModel object;
      
      
      

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
