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
import '../../model/report_inventory_move_model.dart';
import '../../model/warehouse_model.dart';
import '../../repository/inventory_concepts_repo.dart';
import '../../repository/warehouses_repo.dart';
import 'inventory_move_state.dart';

class InventoryMoveCubit extends Cubit<InventoryMoveState> {
  InventoryMoveCubit() : super(InitialInventoryMoveState());

  Future<void> initLoad(InventoryMoveModel form) async {
    try {
      emit(InitialInventoryMoveState());
      emit(LoadingInventoryMoveState());
      List<ConceptMoveModel> conceptList;
      List<WarehouseModel> warehouseList;

      conceptList = await InventoryConceptsRepo().fetchAllConcepts();
      conceptList.sort(
        (a, b) => a.id.compareTo(b.id),
      );
      form.concepts = conceptList;

      form.moveList.add(InventoryMoveRowModel.empty());

      warehouseList = await WarehousesRepo().fetchAllWarehouses();
      warehouseList.sort((a, b) => a.id.compareTo(b.id));
      form.warehouseList = warehouseList;

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
      upMoveRow.product = productDB;
      upMoveRow.weightUnit = productDB.weight!;
      upMoveRow.weightTotal =
          (double.tryParse(moveRow.quantityTf.text) ?? 0) * moveRow.weightUnit;
      upMoveRow.codeState = DataState(state: ElementState.loaded, message: '');
      if (moveRow.quantityState.state == ElementState.error) {
        enterQuantity(index, warehouse, form);
      }
    } else {
      upMoveRow.codeState =
          DataState(state: ElementState.error, message: moveRow.emNotProduct);
      upMoveRow.product = ProductModel.empty();
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
    final quantity = double.tryParse(form.moveList[index].quantityTf.text) ?? 0;

    emit(InitialInventoryMoveState());
    form.moveList[index].quantityState =
        DataState(state: ElementState.loading, message: '');
    emit(LoadedInventoryMoveState());

    inventoryRow = await InventoryRepo()
        .fetchRowByCode(form.moveList[index].codeTf.text, warehouse.name);

    if (form.concept.type == 1 && inventoryRow != null) {
      if (quantity > inventoryRow.stock &&
          form.concepts.where((x) => x.text == form.concept.text).first.type ==
              1) {
        form.moveList[index].quantityState =
            DataState(state: ElementState.error, message: moveRow.emNotStock);
      } else {
        form.moveList[index].weightTotal =
            quantity * form.moveList[index].weightUnit;
        form.moveList[index].quantityState =
            DataState(state: ElementState.loaded, message: '');
      }
    } else {
      productDB =
          await ProductRepo().fetchProduct(form.moveList[index].codeTf.text);
      if (form.concept.type == 0 && productDB != null) {
        form.moveList[index].weightTotal =
            quantity * form.moveList[index].weightUnit;
        form.moveList[index].quantityState =
            DataState(state: ElementState.loaded, message: '');
      } else {
        form.moveList[index].quantityState =
            DataState(state: ElementState.error, message: moveRow.emNotStock);
      }
    }

    if (form.moveList[index].product.description == '' &&
        form.moveList[index].codeState.state != ElementState.error) {
      enterCode(index, form, warehouse);
    }

    emit(InitialInventoryMoveState());
    emit(LoadedInventoryMoveState());
  }

  Future<void> allValidate(
      InventoryMoveModel form, WarehouseModel warehouse) async {
    emit(InitialInventoryMoveState());
    emit(LoadingInventoryMoveState());

    ProductModel? productDB;
    InventoryModel? inventoryRow;
    InventoryMoveRowModel moveRow;

    for (int i = 0; i < form.moveList.length; i++) {
      final quantity = double.tryParse(form.moveList[i].quantityTf.text) ?? 0;
      moveRow = form.moveList[i];
      productDB =
          await ProductRepo().fetchProduct(form.moveList[i].codeTf.text);
      if (productDB != null) {
        form.moveList[i].product = productDB;
        form.moveList[i].weightUnit = productDB.weight!;
        form.moveList[i].weightTotal = quantity * form.moveList[i].weightUnit;
        form.moveList[i].codeState =
            DataState(state: ElementState.loaded, message: '');
      } else {
        form.moveList[i].codeState = DataState(
            state: ElementState.error, message: form.moveList[i].emNotProduct);
        form.moveList[i].product = ProductModel.empty();
        form.moveList[i].weightUnit = 0;
      }

      inventoryRow = await InventoryRepo()
          .fetchRowByCode(form.moveList[i].codeTf.text, warehouse.name);
      if (form.concept.type == 1 && inventoryRow != null) {
        if (quantity > inventoryRow.stock &&
            form.concepts
                    .where((x) => x.text == form.concept.text)
                    .first
                    .type ==
                1) {
          form.moveList[i].quantityState =
              DataState(state: ElementState.error, message: moveRow.emNotStock);
        } else {
          form.moveList[i].weightTotal = quantity * form.moveList[i].weightUnit;
          form.moveList[i].quantityState =
              DataState(state: ElementState.loaded, message: '');
        }
      } else if (form.concept.type == 0 && productDB != null) {
        form.moveList[i].weightTotal = quantity * form.moveList[i].weightUnit;
        form.moveList[i].quantityState =
            DataState(state: ElementState.loaded, message: '');
      } else {
        form.moveList[i].quantityState =
            DataState(state: ElementState.error, message: moveRow.emNotStock);
      }
    }
    //emit(InitialInventoryMoveState());
    emit(LoadedInventoryMoveState());
  }

  Future<void> save(InventoryMoveModel form, WarehouseModel warehouse) async {
    //InventoryMoveModel upForm = form;
    final ReportInventoryMoveModel reportData;
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
      await allValidate(form, warehouse);
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
        for (int i = 0; i < form.moveList.length; i++) {
          final element = form.moveList[i];
          final quantity = double.tryParse(element.quantityTf.text) ?? 0;
          if (element.codeTf.text == '' && quantity < 1) {
            form.moveList.removeAt(i);
            i--;
          }
        }
        for (var element in form.moveList) {
          final quantity = double.tryParse(element.quantityTf.text) ?? 0;
          if (element.codeTf.text == '' || quantity < 1) {
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
        if (mapMoveList.keys.contains(moveRow.codeTf.text)) {
          var row = mapMoveList[moveRow.codeTf.text]!;
          final rowQuantity = double.tryParse(row.quantityTf.text) ?? 0;
          final moveRowQuantity = double.tryParse(moveRow.quantityTf.text) ?? 0;
          row.quantityTf.text = '${rowQuantity + moveRowQuantity}';
          row.weightTotal = rowQuantity * row.weightUnit;
          mapMoveList[moveRow.codeTf.text] = row;
        } else {
          mapMoveList[moveRow.codeTf.text] = moveRow;
        }
      }
      upMoveList = mapMoveList.values.toList();

      //Obtiene los registros de inventario actuales de la lista reducida
      emit(LoadingInventoryMoveState());
      inventoryMap = {};
      for (var row in form.moveList) {
        inventoryRow = await InventoryRepo()
            .fetchRowByCode(row.codeTf.text, warehouse.name);
        if (inventoryRow != null) {
          inventoryMap[row.codeTf.text] = inventoryRow;
        } else {
          inventoryMap[row.codeTf.text] =
              InventoryModel.stockZero(row.codeTf.text, warehouse);
        }
      }

      //Crea un registro de movimiento por cada fila de la lista actualizada.
      form.moveList = upMoveList;
      user = await LocalUser().getLocalUser();
      final folio = await MovementRepo().fetchAvailableFolio();
      for (var row in form.moveList) {
        final rowQuantity = double.tryParse(row.quantityTf.text) ?? 0;
        if (form.concept.type == 0) {
          stock = inventoryMap[row.codeTf.text]!.stock + rowQuantity;
        } else {
          stock = inventoryMap[row.codeTf.text]!.stock - rowQuantity;
        }
        if (stock < 0) {
          form.states[form.tSave]!.state = ElementState.error;
          form.states[form.tSave]!.message = form.emNotStock;
          emit(ErrorInventoryMoveState(error: form.emNotStock));
          return;
        } else {
          inventoryMap[row.codeTf.text]!.stock = stock;
        }
        regMove = MovementModel.fromRowOfDoc(
            form, row, warehouse, user.name, stock, folio);
        regMoveList.add(regMove);
        inventoryList = inventoryMap.values.toList();
      }

      //Si el concepto es una salida de traspaso, obtiene los registors de
      //inventario y crea los registros extra de entrada para el inventario destino.
      if (form.concept.id == 58) {
        inventoryMap = {};
        for (var row in form.moveList) {
          inventoryRow = await InventoryRepo()
              .fetchRowByCode(row.codeTf.text, form.invTransfer.name);
          if (inventoryRow != null) {
            inventoryMap[row.codeTf.text] = inventoryRow;
          } else {
            inventoryMap[row.codeTf.text] =
                InventoryModel.stockZero(row.codeTf.text, form.invTransfer);
          }
        }
        for (var row in form.moveList) {
          final rowQuantity = double.tryParse(row.quantityTf.text) ?? 0;
          stock = inventoryMap[row.codeTf.text]!.stock + rowQuantity;
          inventoryMap[row.codeTf.text]!.stock = stock;
          regMove = MovementModel.transferDestiny(
              form, row, form.invTransfer, user.name, stock, folio);
          regMoveList.add(regMove);
          inventoryListDestiny = inventoryMap.values.toList();
        }
      }
    } catch (e) {
      emit(ErrorInventoryMoveState(error: e.toString()));
    } finally {
      if (state is LoadedInventoryMoveState ||
          state is LoadingInventoryMoveState) {
        //Guarda los registros en caso de no existir errores.
        //Lista con movimientos a registrar: regMoveList
        await MovementRepo().insertMovemets(regMoveList);
        //Lista con registros de inventario nuevos: inventoryList
        await InventoryRepo().updateInventory(inventoryList);
        //Lista con registros de inventario destino: inventoryListDestiny
        await InventoryRepo().updateInventory(inventoryListDestiny);

        if (form.concept.id == 58) {
            reportData = ReportInventoryMoveModel.transfer(
              dateTime: form.date,
              document: form.document.text,
              warehouse: warehouse,
              warehouseDestiny: form.invTransfer,
              productList:
                  ReportInventoryMoveModel.movesToReportRows(form.moveList),
            );
          } else {
            reportData = ReportInventoryMoveModel.singleMove(
              warehouse: warehouse,
              dateTime: form.date,
              document: form.document.text,
              productList:
                  ReportInventoryMoveModel.movesToReportRows(form.moveList),
              concept: form.concept,
            );
          }
        emit(SavedInventoryMoveState(reportData: reportData));
      }
    }
  }
}

class InventoryMoveForm extends Cubit<InventoryMoveModel> {
  InventoryMoveForm() : super(InventoryMoveModel.empty());
}
