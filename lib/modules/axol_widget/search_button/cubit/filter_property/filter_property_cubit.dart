import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/filter_property_form_model.dart';
import 'filter_property_state.dart';

class FilterPropCubit extends Cubit<FilterPropState> {
  FilterPropCubit() : super(InitialFilterPropState());

  Future<void> load() async {
    try {
      emit(InitialFilterPropState());
      emit(LoadingFilterPropState());

      emit(LoadedFilterPropState());
    } catch (e) {
      emit(InitialFilterPropState());
      emit(ErrorFilterPropState(error: e.toString()));
    }
  }

  Future<void> initLoad(
      FilterPropFormModel form, List<PropChecked> propCheckedList) async {
    try {
      emit(InitialFilterPropState());
      emit(LoadingFilterPropState());

      for (PropChecked propChecked in propCheckedList) {
        form.propCheckedList.add(propChecked);
        form.propCheckedView.add(propChecked);
      }

      emit(LoadedFilterPropState());
    } catch (e) {
      emit(InitialFilterPropState());
      emit(ErrorFilterPropState(error: e.toString()));
    }
  }

  Future<void> find(FilterPropFormModel form) async {
    try {
      emit(InitialFilterPropState());
      emit(LoadingFilterPropState());
      List<PropChecked> list;
      final String text = form.finderController.text.toLowerCase();

      list = form.propCheckedList
          .where((x) => x.property.name.toLowerCase().contains(text))
          .toList();
      form.propCheckedView = [];
      for (PropChecked propChecked in list) {
        form.propCheckedView.add(propChecked);
      }

      emit(LoadedFilterPropState());
    } catch (e) {
      emit(InitialFilterPropState());
      emit(ErrorFilterPropState(error: e.toString()));
    }
  }

  Future<void> check(FilterPropFormModel form, int index, bool? value) async {
    try {
      emit(InitialFilterPropState());
      emit(LoadingFilterPropState());

      if (value != null) {
        form.propCheckedList[index].checked = value;
      }

      emit(LoadedFilterPropState());
    } catch (e) {
      emit(InitialFilterPropState());
      emit(ErrorFilterPropState(error: e.toString()));
    }
  }
}

class FilterPropForm extends Cubit<FilterPropFormModel> {
  FilterPropForm() : super(FilterPropFormModel.empty());
}
