import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';
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

      for (PropertyModel prop in link.block.propertyList) {
        final String cell;
        if (object.map[prop.key] is String) {
          cell = object.map[prop.key] as String;
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

  Future<void> editState(RowDetailsFormModel form) async {
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

  Future<void> save(RowDetailsFormModel form, WidgetLinkModel link,
      ObjectModel object) async {
    try {
      emit(InitialRowDetailsState());
      emit(LoadingRowDetailsState());
      await ObjectRepo.
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
