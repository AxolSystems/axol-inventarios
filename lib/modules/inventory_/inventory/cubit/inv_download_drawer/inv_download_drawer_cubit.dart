import 'package:axol_inventarios/models/data_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/inventory_row_model.dart';
import '../../../../../utilities/format.dart';
import '../../../../sale_report/model/salereport_model.dart';
import '../../../../sale_report/repository/salereport_repo.dart';
import '../../../movements/model/movement_model.dart';
import '../../../movements/model/movement_response_model.dart';
import '../../../movements/repository/movement_repo.dart';
import '../../model/inv_download_form_model.dart';
import '../../model/warehouse_model.dart';
import '../../repository/inventory_file_repo.dart';
import '../../repository/inventory_repo.dart';
import 'inv_download_drawer_state.dart';

class InvDownloadDrawerCubit extends Cubit<InvDownloadDrawerState> {
  InvDownloadDrawerCubit() : super(InitialInvDownloadDrawerState());

  Future<void> initLoad(InvDownloadFormModel form) async {
    try {
      emit(InitialInvDownloadDrawerState());
      emit(LoadingInvDownloadDrawerState());
      form.timeInventory = DateTime.now();
      emit(LoadedInvDownloadDrawerState());
    } catch (e) {
      emit(InitialInvDownloadDrawerState());
      emit(ErrorInvDownloadDrawerState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialInvDownloadDrawerState());
      emit(LoadingInvDownloadDrawerState());

      emit(LoadedInvDownloadDrawerState());
    } catch (e) {
      emit(InitialInvDownloadDrawerState());
      emit(ErrorInvDownloadDrawerState(error: e.toString()));
    }
  }

  Future<void> csvSubSale(
      String idListText, List<InventoryRowModel> inventoryRowList) async {
    try {
      emit(InitialInvDownloadDrawerState());
      emit(LoadingInvDownloadDrawerState());
      List<SaleReportModel> reportList;
      int? id;
      List<int> idList = [];

      for (String element in idListText.split(',')) {
        id = int.tryParse(element);
        if (id != null) {
          idList.add(id);
        }
      }

      reportList = await SaleReportRepo.fetchSaleReportById(idList);
      await InventoryCsv.invSubSaleCsv(inventoryRowList, reportList);

      emit(LoadedInvDownloadDrawerState());
    } catch (e) {
      emit(InitialInvDownloadDrawerState());
      emit(ErrorInvDownloadDrawerState(error: e.toString()));
    }
  }

  Future<void> csvInventory(WarehouseModel warehouse,
      List<InventoryRowModel> inventoryRowList) async {
    try {
      emit(InitialInvDownloadDrawerState());
      emit(LoadingInvDownloadDrawerState());
      List<InventoryRowModel> inventoryList;
      DataResponseModel dataResponse;

      dataResponse =
          await InventoryRepo().fetchInventoryList('', warehouse.name);
      inventoryList = dataResponse.dataList as List<InventoryRowModel>;
      await InventoryCsv.inventoryCsv(inventoryList, warehouse);

      emit(LoadedInvDownloadDrawerState());
    } catch (e) {
      emit(InitialInvDownloadDrawerState());
      emit(ErrorInvDownloadDrawerState(error: e.toString()));
    }
  }

  Future<void> csvInvToDate(WarehouseModel warehouse, InvDownloadFormModel form) async {
    try {
      emit(InitialInvDownloadDrawerState());
      emit(LoadingInvDownloadDrawerState());
      List<InventoryRowModel> inventoryList;
      List<MovementModel> moveList;
      List<String> omitList;
      MovementResponseModel movementResponse;
      DataResponseModel dataResponse;

      //Toma la lista de elementos a omitir del controlador.
      omitList = form.tfOmit.text.split(',');

      //Descargar movimientos entre la fecha seleccionada y la fehca actual
      movementResponse = await MovementRepo().fetchMoveInRangeTime(
        startTime: FormatDate.startDay(form.timeInventory),
        endTime: DateTime.now(),
        warehouseId: warehouse.id,
      );
      moveList = movementResponse.movementList;

      //Elimina de la lista de movimientos los folios de la ista a omitir.
      print(moveList.length);
      for (var element in omitList) {
        final folio = int.tryParse(element) ?? -1;
        moveList.removeWhere((x) => x.folio == folio);
        print(moveList.length);
      }

      //Descargar inventario
      dataResponse =
          await InventoryRepo().fetchInventoryList('', warehouse.name);
      inventoryList = dataResponse.dataList as List<InventoryRowModel>;

      //Restar al inventario los movimientos obtenidos en el paso anterior
      for (int i = 0; i < moveList.length; i++) {
        final MovementModel move = moveList[i];
        final double qty;
        final int iSet = inventoryList.indexWhere((x) => x.product.code == move.code);
        if (iSet != -1) {
          if (move.conceptType == 1) {
            qty = move.quantity;
          } else if (move.conceptType == 0) {
            qty = move.quantity * -1;
          } else {
            qty = 0;
          }
          inventoryList[iSet] = InventoryRowModel.setStock(inventoryRow: inventoryList[iSet], stock: inventoryList[iSet].stock + qty);
        }
      }

      //Descarga archivo csv
      await InventoryCsv.inventoryCsv(inventoryList, warehouse);

      emit(LoadedInvDownloadDrawerState());
    } catch (e) {
      emit(InitialInvDownloadDrawerState());
      emit(ErrorInvDownloadDrawerState(error: e.toString()));
    }
  }
}

class InvDownloadForm extends Cubit<InvDownloadFormModel> {
  InvDownloadForm() : super(InvDownloadFormModel.empty());
}
