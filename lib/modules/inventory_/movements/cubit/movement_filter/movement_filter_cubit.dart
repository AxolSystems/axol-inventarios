import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/format.dart';
import '../../../inventory/model/warehouse_model.dart';
import '../../../inventory/repository/warehouses_repo.dart';
import '../../model/movement_filter_form_model.dart';
import '../../model/movement_filter_model.dart';
import 'movement_filter_state.dart';

class MovementFilterCubit extends Cubit<MovementFilterState> {
  MovementFilterCubit() : super(InitialMovementFilterState());

  Future<void> initLoad(
      MovementFilterFormModel form, MovementFilterModel filter) async {
    try {
      emit(InitialMovementFilterState());
      emit(LoadingMovementFilterState());
      List<WarehouseModel> warehouseList;
      warehouseList = await WarehousesRepo().fetchAllWarehouses();
      form.warehouseList = warehouseList;
      form.endDate = FormatDate.endDay(filter.endDate);
      form.initDate = FormatDate.startDay(filter.initDate);
      form.filterDate = filter.filterDate;
      form.tfWarehose.controller.value =
          TextEditingValue(text: filter.warehouse.name);
      //print('init: ${FormatDate.}');
      //print('end: ${FormatDate.dmy(form.endDate)}');
      emit(LoadedMovementFilterState());
    } catch (e) {
      emit(ErrorMovementFilterState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialMovementFilterState());
      emit(LoadingMovementFilterState());
      emit(LoadedMovementFilterState());
    } catch (e) {
      emit(ErrorMovementFilterState(error: e.toString()));
    }
  }

  Future<void> save(MovementFilterFormModel form) async {
    try {
      emit(InitialMovementFilterState());
      emit(LoadingMovementFilterState());
      MovementFilterModel filter;
      WarehouseModel? warehouse;
      List<WarehouseModel> warehouseList = form.warehouseList
            .where((x) => x.name == form.tfWarehose.controller.text).toList();

      if (warehouseList.isNotEmpty) {
        warehouse = warehouseList.first;
      }
      if (form.initDate.millisecondsSinceEpoch >
          form.endDate.millisecondsSinceEpoch) {
        emit(const ErrorMovementFilterState(
            error: 'La fecha final no puede ser mayor a la inicial'));
        return;
      }

      filter = MovementFilterModel(
        initDate: form.initDate,
        endDate: form.endDate,
        warehouse: warehouse ?? WarehouseModel.empty(),
        filterDate: form.filterDate,
        document: [],
        folio: [],
        concept: [],
      );
      emit(SavedMovementFilterState(filter: filter));
    } catch (e) {
      emit(ErrorMovementFilterState(error: e.toString()));
    }
  }
}
