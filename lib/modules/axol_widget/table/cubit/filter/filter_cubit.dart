import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/filter_form_model.dart';
import 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(InitialFilterState());

  Future<void> load() async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());

      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }

  Future<void> initLoad(FilterFormModel form) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      form.filterList.add(AddFilterModel());
      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }
}

class FilterForm extends Cubit<FilterFormModel> {
 FilterForm() : super(FilterFormModel.empty()); 
}