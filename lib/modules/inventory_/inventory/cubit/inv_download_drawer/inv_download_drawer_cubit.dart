import 'package:axol_inventarios/models/data_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/inventory_row_model.dart';
import '../../../../sale_report/model/salereport_model.dart';
import '../../../../sale_report/repository/salereport_repo.dart';
import '../../model/inv_download_form_model.dart';
import '../../model/warehouse_model.dart';
import '../../repository/inventory_file_repo.dart';
import '../../repository/inventory_repo.dart';
import 'inv_download_drawer_state.dart';

class InvDownloadDrawerCubit extends Cubit<InvDownloadDrawerState> {
  InvDownloadDrawerCubit() : super(InitialInvDownloadDrawerState());

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
}

class InvDownloadForm extends Cubit<InvDownloadFormModel> {
  InvDownloadForm() : super(InvDownloadFormModel.empty());
}
