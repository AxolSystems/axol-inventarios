import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../block/model/block_model.dart';
import '../../../../object/model/filter_obj_model.dart';
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

  Future<void> changeDropdownProp(
      FilterFormModel form, BlockModel block, dynamic value, int index) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      if (value != null) {
        final PropertyModel prop = PropertyModel(
            name: block.propertyList
                .firstWhere((x) => x.key == value.toString())
                .name,
            propertyType: block.propertyList
                .firstWhere((x) => x.key == value.toString())
                .propertyType,
            key: value.toString());
        if (prop.propertyType == Prop.text) {
          form.filterList[index] = TextFilterModel(
            ctrlValue: TextEditingController(),
            property: prop,
            operatorList: [
              FilterOperator.eq,
              FilterOperator.like,
              FilterOperator.ilike
            ],
            operator: FilterOperator.eq,
          );
        }
      }
      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }

  Future<void> changeDropdownOper(
      FilterFormModel form, dynamic value, int index) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      if (value is FilterOperator &&
          form.filterList[index] is TextFilterModel) {
        final TextFilterModel textFilter =
            form.filterList[index] as TextFilterModel;
        form.filterList[index] = TextFilterModel(
            ctrlValue: textFilter.ctrlValue,
            property: textFilter.property,
            operatorList: textFilter.operatorList,
            operator: value);
      }
      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }

  Future<void> apply(FilterFormModel form) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      List<FilterObjModel> filters = [];
      FilterObjModel filter;
      dynamic value;
      for (FilterModel flt in form.filterList) {

        if (flt is TextFilterModel) {
          value = flt.ctrlValue.text;
        }
        if (flt is! EmptyFilterModel && flt is! AddFilterModel) {
          filter = FilterObjModel(
              property: flt.property, value: value, operator: flt.operator);
          filters.add(filter);
        }
      }
      emit(ApplyFilterState(filters: filters));
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
