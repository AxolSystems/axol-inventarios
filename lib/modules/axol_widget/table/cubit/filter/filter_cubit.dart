import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../block/model/block_model.dart';
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

  Future<void> initLoad(FilterFormModel form, BlockModel block) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      List<PropertyModel> properties = [PropertyModel.empty()];

      for (PropertyModel prop in block.propertyList) {
        properties.add(prop);
      }

      form.filterList.add(AddFilterModel());
      form.block = BlockModel(
        blockName: block.blockName,
        propertyList: properties,
        tableName: block.tableName,
        uuid: block.uuid,
      );
      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }

  Future<void> add(FilterFormModel form) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      form.filterList
          .insert(form.filterList.length - 1, EmptyFilterModel.empty());
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
