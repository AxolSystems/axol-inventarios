import 'package:axol_inventarios/modules/inventory_/inventory/model/inventory_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/repository/inventory_repo.dart';
import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:axol_inventarios/modules/inventory_/product/repository/product_repo.dart';
import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:axol_inventarios/modules/user/repository/user_repo.dart';
import 'package:axol_inventarios/utilities/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../movements/model/movement_model.dart';
import '../../../movements/repository/movement_repo.dart';
import '../../model/inventory_move/concept_move_model.dart';
import '../../model/inventory_move/inventory_move_model.dart';
import '../../model/inventory_move/inventory_move_row_model.dart';
import '../../model/warehouse_model.dart';
import '../../repository/inventory_concepts_repo.dart';
import 'inventory_move_state.dart';

class InventoryMoveCubit extends Cubit<InventoryMoveState> {
  InventoryMoveCubit() : super(InitialInventoryMoveState());

  Future<void> initLoad(InventoryMoveModel form) async {
    try {
      emit(InitialInventoryMoveState());
      emit(LoadingInventoryMoveState());
      List<ConceptMoveModel> conceptList;

      conceptList = await InventoryConceptsRepo().fetchAllConcepts();
      conceptList.sort(
        (a, b) => a.id.compareTo(b.id),
      );
      form.concepts = conceptList;
      form.moveList.add(InventoryMoveRowModel.empty());

      emit(LoadedInventoryMoveState());
    } catch (e) {
      emit(ErrorInventoryMoveState(error: e.toString()));
    }
  }

  Future<void> load(InventoryMoveModel form) async {
    try {
      emit(InitialInventoryMoveState());
      emit(LoadingInventoryMoveState());

      emit(LoadedInventoryMoveState());
    } catch (e) {
      emit(ErrorInventoryMoveState(error: e.toString()));
    }
  }

  Future<void> enterCode(
      int index, InventoryMoveModel form, WarehouseModel warehouse) async {
    emit(InitialInventoryMoveState());
    emit(LoadedInventoryMoveState());
    final ProductModel? productDB;
    final InventoryMoveRowModel moveRow = form.moveList[index];
    InventoryMoveRowModel upMoveRow = moveRow;

    form.moveList[index].codeState =
        DataState(state: ElementState.loading, message: '');
    emit(InitialInventoryMoveState());
    emit(LoadedInventoryMoveState());

    //Buscar currentCode en la base de datos y obtiene los datos necesarios.
    productDB =
        await ProductRepo().fetchProduct(form.moveList[index].codeTf.text);

    //Sí el producto existe, lo agrega a la lista de movimientos que está por
    // emitir.
    if (productDB != null) {
      upMoveRow.description = productDB.description;
      upMoveRow.weightUnit = productDB.weight!;
      upMoveRow.weightTotal = (double.tryParse(moveRow.quantityTf.text) ?? 0) * moveRow.weightUnit;
      upMoveRow.codeState = DataState(state: ElementState.loaded, message: '');
    } else {
      upMoveRow.codeState =
          DataState(state: ElementState.error, message: moveRow.emNotProduct);
      upMoveRow.description = '';
      upMoveRow.weightUnit = 0;
    }
    form.moveList[index] = upMoveRow;
    emit(InitialInventoryMoveState());
    emit(LoadedInventoryMoveState());
  }

  Future<void> enterQuantity(
      int index, WarehouseModel warehouse, InventoryMoveModel form) async {
    final InventoryMoveRowModel moveRow = form.moveList[index];
    InventoryModel? inventoryRow;
    final ProductModel? productDB;

    emit(InitialInventoryMoveState());
    form.moveList[index].quantityState =
        DataState(state: ElementState.loading, message: '');
    emit(LoadedInventoryMoveState());

    inventoryRow = await InventoryRepo()
        .fetchRowByCode(form.moveList[index].codeTf.text, warehouse.name);
    productDB =
        await ProductRepo().fetchProduct(form.moveList[index].codeTf.text);

    if (form.concept.type == 1 && inventoryRow != null) {
      if (double.parse(form.moveList[index].quantityTf.text) >
              inventoryRow.stock &&
          form.concepts.where((x) => x.text == form.concept.text).first.type ==
              1) {
        form.moveList[index].quantityState =
            DataState(state: ElementState.error, message: moveRow.emNotStock);
      } else {
        form.moveList[index].weightTotal =
            (double.tryParse(form.moveList[index].quantityTf.text) ??
                0) * form.moveList[index].weightUnit;
        form.moveList[index].quantityState =
            DataState(state: ElementState.loaded, message: '');
      }
    } else if (form.concept.type == 0 && productDB != null) {
      form.moveList[index].weightTotal =
          (double.tryParse(form.moveList[index].quantityTf.text) ??
              0) * form.moveList[index].weightUnit;
      form.moveList[index].quantityState =
          DataState(state: ElementState.loaded, message: '');
    } else {
      form.moveList[index].quantityState =
          DataState(state: ElementState.error, message: moveRow.emNotStock);
    }

    emit(InitialInventoryMoveState());
    emit(LoadedInventoryMoveState());
  }

  Future<void> saveMovements(
      final InventoryMoveModel form, final WarehouseModel warehouse) async {
    InventoryMoveModel upForm = form;
    MovementModel regMove;
    List<MovementModel> regMoveList = [];
    double stock = 0;
    List<InventoryMoveRowModel> upMoveList;
    Map<String, InventoryMoveRowModel> mapMoveList = {};
    UserModel user;
    Map<String, InventoryModel> inventoryMap = {};
    InventoryModel? inventoryRow;
    List<InventoryModel> inventoryList = [];
    List<InventoryModel> inventoryListDestiny = [];

    try {
      emit(InitialInventoryMoveState());
      emit(LoadedInventoryMoveState());
      //Valida si se seleccionó un concepto.
      if (form.concept.text == '') {
        form.states[form.tSave]!.state = ElementState.error;
        form.states[form.tSave]!.message = form.emSelectConcept;
        emit(ErrorInventoryMoveState(error: form.emSelectConcept));
        return;
      }

      //Valida si se hay al menos una fila en la lista de movimientos.
      if (form.moveList.isEmpty) {
        form.states[form.tSave]!.state = ElementState.error;
        form.states[form.tSave]!.message = form.emNotRow;
        emit(ErrorInventoryMoveState(error: form.emNotRow));
        return;
      } else {
        for (var element in form.moveList) {
          final quantity = double.tryParse(element.quantityTf.text) ?? 0;
          if (element.code == '' ||  quantity <= 1) {
            form.states[form.tSave]!.state = ElementState.error;
            form.states[form.tSave]!.message = form.emRowMissing;
            emit(ErrorInventoryMoveState(error: form.emRowMissing));
            return;
          }
        }
      }

      //Valida si hay algún error en las filas de la lista.
      for (var moveRow in form.moveList) {
        if (moveRow.codeState.state == ElementState.error) {
          form.states[form.tSave]!.state = ElementState.error;
          form.states[form.tSave]!.message = form.emNotProduct;
          emit(ErrorInventoryMoveState(error: form.emNotProduct));
          return;
        }
        if (moveRow.quantityState.state == ElementState.error) {
          form.states[form.tSave]!.state = ElementState.error;
          form.states[form.tSave]!.message = form.emNotStock;
          emit(ErrorInventoryMoveState(error: form.emNotStock));
          return;
        }
      }

      //Reduce las filas sumando los que tienene la misma clave.
      for (var moveRow in form.moveList) {
        if (mapMoveList.keys.contains(moveRow.code)) {
          var row = mapMoveList[moveRow.code]!;
          row.quantity = row.quantity + moveRow.quantity;
          row.weightTotal = row.quantity * row.weightUnit;
          mapMoveList[moveRow.code] = row;
        } else {
          mapMoveList[moveRow.code] = moveRow;
        }
      }
      upMoveList = mapMoveList.values.toList();

      //Obtiene los registros de inventario actuales de la lista reducida
      for (var row in upForm.moveList) {
        inventoryRow =
            await InventoryRepo().fetchRowByCode(row.code, warehouse.name);
        if (inventoryRow != null) {
          inventoryMap[row.code] = inventoryRow;
        } else {
          inventoryMap[row.code] =
              InventoryModel.stockZero(row.code, warehouse);
        }
      }

      //Crea un registro de movimiento por cada fila de la lista actualizada.
      upForm.moveList = upMoveList;
      user = await LocalUser().getLocalUser();
      final folio = await MovementRepo().fetchAvailableFolio();
      for (var row in upForm.moveList) {
        if (upForm.concept.type == 0) {
          stock = inventoryMap[row.code]!.stock + row.quantity;
        } else {
          stock = inventoryMap[row.code]!.stock - row.quantity;
        }
        if (stock < 0) {
          form.states[form.tSave]!.state = ElementState.error;
          form.states[form.tSave]!.message = form.emNotStock;
          emit(ErrorInventoryMoveState(error: form.emNotStock));
          return;
        } else {
          inventoryMap[row.code]!.stock = stock;
        }
        regMove = MovementModel.fromRowOfDoc(
            upForm, row, warehouse, user.name, stock, folio);
        regMoveList.add(regMove);
        inventoryList = inventoryMap.values.toList();
      }

      //Si el concepto es una salida de traspaso, obtiene los registors de
      //inventario y crea los registros extra de entrada para el inventario destino.
      if (upForm.concept.id == 58) {
        inventoryMap = {};
        for (var row in upForm.moveList) {
          inventoryRow = await InventoryRepo()
              .fetchRowByCode(row.code, upForm.invTransfer.name);
          if (inventoryRow != null) {
            inventoryMap[row.code] = inventoryRow;
          } else {
            inventoryMap[row.code] =
                InventoryModel.stockZero(row.code, warehouse);
          }
        }
        for (var row in upForm.moveList) {
          stock = inventoryMap[row.code]!.stock + row.quantity;
          regMove = MovementModel.transferDestiny(
              upForm, row, upForm.invTransfer, user.name, stock, folio);
          regMoveList.add(regMove);
          inventoryListDestiny = inventoryMap.values.toList();
        }
      }
    } catch (e) {
      emit(ErrorInventoryMoveState(error: e.toString()));
    } finally {
      if (state is LoadedInventoryMoveState) {
        //Guarda los registros en caso de no existir errores.
        //Lista con movimientos a registrar: regMoveList
        await MovementRepo().insertMovemets(regMoveList);
        //Lista con registros de inventario nuevos: inventoryList
        await InventoryRepo().updateInventory(inventoryList);
        //Lista con registros de inventario destino: inventoryListDestiny
        await InventoryRepo().updateInventory(inventoryListDestiny);
        emit(SavedInventoryMoveState());
      }
    }
  }
}

class InventoryMoveForm extends Cubit<InventoryMoveModel> {
  InventoryMoveForm() : super(InventoryMoveModel.empty());
}
