import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      form.endDate = filter.endDate;
      form.initDate = filter.initDate;
      form.filterDate = filter.filterDate;
      form.tfWarehose.controller.value =
          TextEditingValue(text: filter.warehouse.name);
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
      emit(LoadedMovementFilterState());
    } catch (e) {
      emit(ErrorMovementFilterState(error: e.toString()));
    }
  }
}
