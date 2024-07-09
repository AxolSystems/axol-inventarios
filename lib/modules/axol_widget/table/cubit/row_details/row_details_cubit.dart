import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../block/model/property_model.dart';
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

  Future<void> initLoad(RowDetailsFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialRowDetailsState());
      emit(LoadingRowDetailsState());

      for (PropertyModel prop in link.block.propertyList) {
        form.controllers[prop.key] = TextEditingController();
      }

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
