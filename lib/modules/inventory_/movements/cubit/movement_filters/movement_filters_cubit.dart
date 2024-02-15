import 'package:axol_inventarios/modules/inventory_/inventory/repository/warehouses_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory/model/inventory_move/concept_move_model.dart';
import '../../../../../models/textfield_model.dart';
import '../../../../user/model/user_mdoel.dart';
import '../../../inventory/model/warehouse_model.dart';
import '../../../inventory/repository/inventory_concepts_repo.dart';
import '../../../../user/repository/user_repo.dart';
import '../../model/movement_filter_model.dart';
import 'movement_filters_state.dart';

/*class MovementFiltersCubit extends Cubit<MovementFiltersState> {
  MovementFiltersCubit() : super(InitialState());

  void changeWarehouse(
      MovementFilterModel currentFilter, WarehouseModel warehouse) {
    try {
      MovementFilterModel movementFilter;
      emit(LoadingState());
      movementFilter = MovementFilterModel(
          date: currentFilter.date,
          warehouse: warehouse,
          warehousesList: currentFilter.warehousesList,
          concept: currentFilter.concept,
          conceptsList: currentFilter.conceptsList,
          user: currentFilter.user,
          usersList: currentFilter.usersList,
          currentLimit: currentFilter.currentLimit);
      emit(LoadedState(movementFilters: movementFilter));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> getInitialValues(MovementFilterModel currentFilter) async {
    List<WarehouseModel> warehouses = [];
    List<ConceptMoveModel> concepts = [];
    List<UserModel> users = [];
    MovementFilterModel movementFilter;

    emit(LoadingState());
    warehouses = await WarehousesRepo().fetchAllWarehouses();
    if (warehouses.last.id > -1) {
      warehouses
          .add(const WarehouseModel(id: -1, name: 'TODOS', retailManager: ''));
    }
    concepts = await InventoryConceptsRepo().fetchAllConcepts();
    if (concepts.last.id != -1) {
      concepts.add(
          const ConceptMoveModel(text: 'TODOS', id: -1, type: -1));
    }
    users = await DatabaseUser().fetchAllUsers();
    if (users.last.id != -1) {
      users.add(const UserModel(
          name: 'TODOS', id: -1, rol: '//', password: '//'));
    }
    movementFilter = MovementFilterModel(
        warehousesList: warehouses,
        warehouse: currentFilter.warehouse,
        date: currentFilter.date,
        concept: currentFilter.concept,
        conceptsList: concepts,
        user: currentFilter.user,
        usersList: users,
        currentLimit: currentFilter.currentLimit);
    emit(LoadedState(movementFilters: movementFilter));
  }

  void changeDate(
      MovementFilterModel currentFilter, Map<int, DateTime> dateTime) async {
    MovementFilterModel movementFilter;
    emit(InitialState());
    movementFilter = MovementFilterModel(
        warehousesList: currentFilter.warehousesList,
        warehouse: currentFilter.warehouse,
        date: dateTime,
        concept: currentFilter.concept,
        conceptsList: currentFilter.conceptsList,
        user: currentFilter.user,
        usersList: currentFilter.usersList,
        currentLimit: currentFilter.currentLimit);
    emit(LoadedState(movementFilters: movementFilter));
  }

  void changeConcept(
      MovementFilterModel currentFilter, ConceptMoveModel concept) {
    try {
      MovementFilterModel movementFilter;
      emit(LoadingState());
      movementFilter = MovementFilterModel(
        date: currentFilter.date,
        warehouse: currentFilter.warehouse,
        warehousesList: currentFilter.warehousesList,
        concept: concept,
        conceptsList: currentFilter.conceptsList,
        user: currentFilter.user,
        usersList: currentFilter.usersList,
        currentLimit: currentFilter.currentLimit,
      );
      emit(LoadedState(movementFilters: movementFilter));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  void changeUser(MovementFilterModel currentFilter, UserModel user) {
    try {
      MovementFilterModel movementFilter;
      emit(LoadingState());
      movementFilter = MovementFilterModel(
        date: currentFilter.date,
        warehouse: currentFilter.warehouse,
        warehousesList: currentFilter.warehousesList,
        concept: currentFilter.concept,
        conceptsList: currentFilter.conceptsList,
        user: user,
        usersList: currentFilter.usersList,
        currentLimit: currentFilter.currentLimit,
      );
      emit(LoadedState(movementFilters: movementFilter));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  void changeLimit(MovementFilterModel currentFilter, int limit, int position) {
    try {
      TextfieldModel currentLimit =
          TextfieldModel(text: limit.toString(), position: position);
      //Map<String, int> currentLimit = {'limit': limit, 'position': position};
      MovementFilterModel movementFilter;
      emit(LoadingState());
      movementFilter = MovementFilterModel(
        date: currentFilter.date,
        warehouse: currentFilter.warehouse,
        warehousesList: currentFilter.warehousesList,
        concept: currentFilter.concept,
        conceptsList: currentFilter.conceptsList,
        user: currentFilter.user,
        usersList: currentFilter.usersList,
        currentLimit: currentLimit,
      );
      emit(LoadedState(movementFilters: movementFilter));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}*/
