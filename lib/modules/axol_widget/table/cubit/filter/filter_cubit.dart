import 'package:axol_inventarios/modules/entity/model/entity_model.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/format.dart';
import '../../../../array/model/array_model.dart';
import '../../../../array/repository/array_repo.dart';
import '../../../../object/model/filter_obj_model.dart';
import '../../../../object/model/object_model.dart';
import '../../../../widget_link/model/widgetlink_model.dart';
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
        final dynamic value;
        if (flt.refObject != null) {
          value = flt.refObject;
        } else {
          value = flt.value;
        }
        
        form.filterList.insert(
            form.filterList.length - 1,
            getFilterModel(
              property: flt.property,
              value: value,
              filterOperator: flt.operator,
            ));
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
      dynamic value, int index, List<WidgetLinkModel> refLinks) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      final WidgetLinkModel referenceLink;
      if (value != null) {
        final PropertyModel prop = PropertyModel(
          name: entity.propertyList
              .firstWhere((x) => x.key == value.toString())
              .name,
          propertyType: entity.propertyList
              .firstWhere((x) => x.key == value.toString())
              .propertyType,
          key: value.toString(),
          dynamicValues: entity.propertyList
              .firstWhere((x) => x.key == value.toString())
              .dynamicValues,
        );

        if (prop.propertyType == Prop.referenceObject) {
          referenceLink = refLinks.firstWhere(
            (x) => x.id == prop.dynamicValues[PropertyModel.dvRefLink],
            orElse: () => WidgetLinkModel.empty(),
          );
          form.filterList[index] = getFilterModel(
            property: prop,
            value: ReferenceObjectModel(
              referenceObject: ObjectModel.empty(),
              idPropertyView: prop.dynamicValues[ReferenceObjectModel.property],
              referenceLink: referenceLink,
            ),
            filterOperator: FilterOperator.eq,
          );
        } else if (prop.propertyType == Prop.array) {
          final String idArray = prop.dynamicValues[PropertyModel.dvIdArray];
          final List<String> list = await ArrayRepo.fetchArrayById(idArray);
          form.filterList[index] = getFilterModel(
            property: prop,
            value: ArrayModel(id: idArray, list: list, value: ''),
            filterOperator: form.filterList[index].operator,
          );
        } else {
          form.filterList[index] = getFilterModel(
            property: prop,
            value: null,
            filterOperator: FilterOperator.eq,
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

      if (value is FilterOperator) {
        final dynamic filterValue;
        if (form.filterList[index] is TextFilterModel) {
          final TextFilterModel flt = form.filterList[index] as TextFilterModel;
          filterValue = flt.ctrlValue.text;
        } else if (form.filterList[index] is NumberFilterModel) {
          final NumberFilterModel flt =
              form.filterList[index] as NumberFilterModel;
          filterValue = double.parse(flt.ctrlValue.text);
        } else if (form.filterList[index] is BooleanFilterModel) {
          final BooleanFilterModel flt =
              form.filterList[index] as BooleanFilterModel;
          filterValue = flt.value;
        } else if (form.filterList[index] is DateFilterModel) {
          final DateFilterModel flt = form.filterList[index] as DateFilterModel;
          filterValue = flt.dateTime.millisecondsSinceEpoch;
        } else if (form.filterList[index] is RefObjFilterModel) {
          final RefObjFilterModel flt =
              form.filterList[index] as RefObjFilterModel;
          filterValue = flt.refObjController;
        } else {
          filterValue = null;
        }
        form.filterList[index] = getFilterModel(
          property: form.filterList[index].property,
          value: filterValue,
          filterOperator: value,
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

      final List<FilterObjModel> filters =
          FilterObjModel.filterToObjFilter(form.filterList);
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

  Future<void> changeArray(FilterFormModel form, int index,
      ArrayFilterModel filter, dynamic value) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      if (value is String) {
        form.filterList[index] = ArrayFilterModel(
          property: filter.property,
          operatorList: filter.operatorList,
          operator: filter.operator,
          arrayFilter: ArrayModel(id: filter.arrayFilter.id, list: filter.arrayFilter.list, value: value),
        );
      }
      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }

  Future<void> thenDateTimePick(
      {required DateTime dateTime,
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

  Future<void> thenAtmObj(
      FilterFormModel form, List<FilterObjModel> filters, int index) async {
    try {
      emit(InitialFilterState());
      emit(LoadingFilterState());
      final AtmObjFilterModel atmObj =
          form.filterList[index] as AtmObjFilterModel;
      List<FilterModel> filterList = [];

      for (FilterObjModel flt in filters) {
        filterList.insert(
            filterList.length,
            getFilterModel(
              property: flt.property,
              value: flt.value,
              filterOperator: flt.operator,
            ));
      }

      form.filterList[index] = AtmObjFilterModel(
        property: atmObj.property,
        operatorList: atmObj.operatorList,
        operator: atmObj.operator,
        filterList: filterList,
      );
      emit(LoadedFilterState());
    } catch (e) {
      emit(InitialFilterState());
      emit(ErrorFilterState(error: e.toString()));
    }
  }

  /// Obtiene el modelo de filtro según la propiedad y tipo de dato de [value].
  /// El valor dinámico deber ser alguno de los siguientes tipos de dato:
  /// - Texto: [String]
  /// - Número: [double]
  /// - Booleano: [bool]
  /// - Fecha: [int]
  /// - Objeto relacional: [ReferenceObjectModel]
  FilterModel getFilterModel(
      {required PropertyModel property,
      required dynamic value,
      required FilterOperator filterOperator}) {
    FilterModel filter = EmptyFilterModel.empty();
    if (property.propertyType == Prop.text) {
      filter = TextFilterModel(
          ctrlValue: TextEditingController(text: value ?? ''),
          property: property,
          operatorList: FilterObjModel.operTextList,
          operator: filterOperator);
    } else if (property.propertyType == Prop.double ||
        property.propertyType == Prop.int) {
      filter = NumberFilterModel(
          ctrlValue: TextEditingController(text: '${value ?? 0}'),
          property: property,
          operatorList: FilterObjModel.operNumberList,
          operator: filterOperator);
    } else if (property.propertyType == Prop.bool) {
      filter = BooleanFilterModel(
          value: value ?? false,
          property: property,
          operatorList: FilterObjModel.operBoolList,
          operator: filterOperator);
    } else if (property.propertyType == Prop.time) {
      filter = DateFilterModel(
          dateTime: FormatDate.secondZero(DateTime.fromMillisecondsSinceEpoch(
              value ?? DateTime.now().millisecondsSinceEpoch)),
          property: property,
          operatorList: FilterObjModel.operDateTimeList,
          operator: filterOperator);
    } else if (property.propertyType == Prop.referenceObject) {
      final ReferenceObjectModel refObj;
      if (value == null) {
        refObj = ReferenceObjectModel.empty();
      } else {
        refObj = value as ReferenceObjectModel;
      }

      final FilterModel referenceFilter;
      if (refObj.getPropView().propertyType == Prop.text) {
        final String valueText =
            refObj.referenceObject.map[refObj.getPropView().key] ?? '';
        referenceFilter = TextFilterModel(
            ctrlValue: TextEditingController(text: valueText),
            property: refObj.getPropView(),
            operatorList: FilterObjModel.operTextList,
            operator: FilterObjModel.operTextList.contains(filterOperator)
                ? filterOperator
                : FilterObjModel.operTextList.first);
      } else if (refObj.getPropView().propertyType == Prop.int ||
          refObj.getPropView().propertyType == Prop.double) {
        final double valueNum =
            refObj.referenceObject.map[refObj.getPropView().key] ?? 0;
        referenceFilter = NumberFilterModel(
          ctrlValue: TextEditingController(text: valueNum.toString()),
          property: refObj.getPropView(),
          operatorList: FilterObjModel.operNumberList,
          operator: FilterObjModel.operNumberList.contains(filterOperator)
              ? filterOperator
              : FilterObjModel.operNumberList.first,
        );
      } else if (refObj.getPropView().propertyType == Prop.bool) {
        final bool valueBool =
            refObj.referenceObject.map[refObj.getPropView().key] ?? false;
        referenceFilter = BooleanFilterModel(
          value: valueBool,
          property: refObj.getPropView(),
          operatorList: FilterObjModel.operBoolList,
          operator: FilterObjModel.operBoolList.contains(filterOperator)
              ? filterOperator
              : FilterObjModel.operBoolList.first,
        );
      } else if (refObj.getPropView().propertyType == Prop.time) {
        final int valueIntDate =
            refObj.referenceObject.map[refObj.getPropView().key] ??
                DateTime.fromMillisecondsSinceEpoch(
                    DateTime.now().millisecondsSinceEpoch);
        referenceFilter = DateFilterModel(
          dateTime: FormatDate.secondZero(
              DateTime.fromMillisecondsSinceEpoch(valueIntDate)),
          property: refObj.getPropView(),
          operatorList: FilterObjModel.operDateTimeList,
          operator: FilterObjModel.operDateTimeList.contains(filterOperator)
              ? filterOperator
              : FilterObjModel.operDateTimeList.first,
        );
      } else {
        referenceFilter = EmptyFilterModel.empty();
      }
      filter = RefObjFilterModel(
        refObjController: refObj,
        referenceFilter: referenceFilter,
        operator: filterOperator,
        operatorList: referenceFilter.operatorList,
        property: property,
      );
    } else if (property.propertyType == Prop.atomicObject) {
      filter = AtmObjFilterModel(
        property: property,
        operatorList: [],
        operator: FilterOperator.eq,
        filterList: value ?? [],
      );
    } else if (property.propertyType == Prop.array) {
      filter = ArrayFilterModel(
        property: property,
        operatorList: FilterObjModel.operArrayList,
        operator: FilterObjModel.operTextList.contains(filterOperator)
            ? filterOperator
            : FilterObjModel.operTextList.first,
        arrayFilter: value ?? ArrayModel.empty(),
      );
    }
    return filter;
  }
}

class FilterForm extends Cubit<FilterFormModel> {
  FilterForm() : super(FilterFormModel.empty());
}
