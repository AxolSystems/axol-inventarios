import 'package:axol_inventarios/modules/entity/model/entity_model.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/format.dart';
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

  Future<void> initLoad(FilterFormModel form, EntityModel entity,
      List<FilterObjModel> filters) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      List<PropertyModel> properties = [PropertyModel.empty()];

      for (PropertyModel prop in entity.propertyList) {
        properties.add(prop);
      }

      form.filterList.add(AddFilterModel());
      for (FilterObjModel flt in filters) {
        if (flt.property.propertyType == Prop.text) {
          form.filterList.insert(
            form.filterList.length - 1,
            TextFilterModel(
                ctrlValue: TextEditingController(text: flt.value.toString()),
                property: flt.property,
                operatorList: FilterObjModel.operTextList,
                operator: flt.operator),
          );
        } else if (flt.property.propertyType == Prop.double ||
            flt.property.propertyType == Prop.int) {
          form.filterList.insert(
            form.filterList.length - 1,
            NumberFilterModel(
                ctrlValue: TextEditingController(text: flt.value.toString()),
                property: flt.property,
                operatorList: FilterObjModel.operNumberList,
                operator: flt.operator),
          );
        } else if (flt.property.propertyType == Prop.bool) {
          form.filterList.insert(
            form.filterList.length - 1,
            BooleanFilterModel(
                value: flt.value,
                property: flt.property,
                operatorList: FilterObjModel.operBoolList,
                operator: flt.operator),
          );
        } else if (flt.property.propertyType == Prop.time) {
          form.filterList.insert(
            form.filterList.length - 1,
            DateFilterModel(
                dateTime: FormatDate.secondZero(
                    DateTime.fromMillisecondsSinceEpoch(flt.value)),
                property: flt.property,
                operatorList: FilterObjModel.operDateTimeList,
                operator: flt.operator),
          );
        }
      }
      form.entity = EntityModel(
        entityName: entity.entityName,
        propertyList: properties,
        tableName: entity.tableName,
        uuid: entity.uuid,
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

  Future<void> changeDropdownProp(FilterFormModel form, EntityModel entity,
      dynamic value, int index) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      if (value != null) {
        final PropertyModel prop = PropertyModel(
            name: entity.propertyList
                .firstWhere((x) => x.key == value.toString())
                .name,
            propertyType: entity.propertyList
                .firstWhere((x) => x.key == value.toString())
                .propertyType,
            key: value.toString());
        if (prop.propertyType == Prop.text) {
          form.filterList[index] = TextFilterModel(
            ctrlValue: TextEditingController(),
            property: prop,
            operatorList: FilterObjModel.operTextList,
            operator: FilterOperator.eq,
          );
        } else if (prop.propertyType == Prop.double ||
            prop.propertyType == Prop.int) {
          form.filterList[index] = NumberFilterModel(
            ctrlValue: TextEditingController(),
            property: prop,
            operatorList: FilterObjModel.operNumberList,
            operator: FilterOperator.eq,
          );
        } else if (prop.propertyType == Prop.bool) {
          form.filterList[index] = BooleanFilterModel(
            value: false,
            property: prop,
            operatorList: FilterObjModel.operBoolList,
            operator: FilterOperator.eq,
          );
        } else if (prop.propertyType == Prop.time) {
          form.filterList[index] = DateFilterModel(
            dateTime: FormatDate.secondZero(DateTime.now()),
            property: prop,
            operatorList: FilterObjModel.operDateTimeList,
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
      } else if (value is FilterOperator &&
          form.filterList[index] is NumberFilterModel) {
        final NumberFilterModel numberFilter =
            form.filterList[index] as NumberFilterModel;
        form.filterList[index] = NumberFilterModel(
            ctrlValue: numberFilter.ctrlValue,
            property: numberFilter.property,
            operatorList: numberFilter.operatorList,
            operator: value);
      } else if (value is FilterOperator &&
          form.filterList[index] is BooleanFilterModel) {
        final BooleanFilterModel booleanFilter =
            form.filterList[index] as BooleanFilterModel;
        form.filterList[index] = BooleanFilterModel(
          value: booleanFilter.value,
          property: booleanFilter.property,
          operatorList: booleanFilter.operatorList,
          operator: value,
        );
      } else if (value is FilterOperator &&
          form.filterList[index] is DateFilterModel) {
        final DateFilterModel dateFilter =
            form.filterList[index] as DateFilterModel;
        form.filterList[index] = DateFilterModel(
          dateTime: dateFilter.dateTime,
          property: dateFilter.property,
          operatorList: dateFilter.operatorList,
          operator: value,
        );
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
        } else if (flt is NumberFilterModel) {
          value = flt.ctrlValue.text;
        } else if (flt is BooleanFilterModel) {
          value = flt.value;
        } else if (flt is DateFilterModel) {
          value = flt.dateTime.millisecondsSinceEpoch;
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

  Future<void> remove(FilterFormModel form, int index) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      form.filterList.removeAt(index);
      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }

  Future<void> changeDropdownBool(FilterFormModel form, int index,
      BooleanFilterModel booleanFilter, dynamic value) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      if (value != null) {
        form.filterList[index] = BooleanFilterModel(
            value: value,
            property: booleanFilter.property,
            operatorList: booleanFilter.operatorList,
            operator: booleanFilter.operator);
      }
      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }

  Future<void> thenDateTimePick(
      {
      required DateTime dateTime,
      required FilterFormModel form,
      required int index}) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      final DateFilterModel dateFilter =
          form.filterList[index] as DateFilterModel;

      form.filterList[index] = DateFilterModel(
        dateTime: dateTime,
        property: dateFilter.property,
        operatorList: dateFilter.operatorList,
        operator: dateFilter.operator,
      );
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
