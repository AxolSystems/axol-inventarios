import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../block/model/property_model.dart';
import '../../../../object/model/object_model.dart';
import '../../../../object/repository/object_repo.dart';
import '../../../../widget_link/model/widgetlink_model.dart';
import '../../model/row_details_form_model.dart';
import 'row_details_state.dart';

class RowDetailsCubit extends Cubit<RowDetailsState> {
  RowDetailsCubit() : super(InitialRowDetailsState());

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
}

class RowDetailsForm extends Cubit<RowDetailsFormModel> {
  RowDetailsForm() : super(RowDetailsFormModel.empty());
}
