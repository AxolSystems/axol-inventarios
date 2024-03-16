import 'package:axol_inventarios/modules/inventory_/inventory/model/report_inventory_row_model.dart';
import 'package:axol_inventarios/modules/inventory_/movements/model/movement_filter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory/model/inventory_move/concept_move_model.dart';
import '../../../inventory/model/report_inventory_move_model.dart';
import '../../../inventory/model/warehouse_model.dart';
import '../../../inventory/repository/inventory_pdf_repo.dart';
import '../../../inventory/repository/warehouses_repo.dart';
import '../../../product/model/product_model.dart';
import '../../../product/repository/product_repo.dart';
import '../../model/movement_model.dart';
import '../../model/movement_pdf_form_model.dart';
import '../../model/movement_response_model.dart';
import '../../repository/movement_files_repo.dart';
import '../../repository/movement_repo.dart';
import 'movement_pdf_state.dart';

class MovementPdfCubit extends Cubit<MovementPdfState> {
  MovementPdfCubit() : super(InitialMovePdfState());

  Future<void> load() async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMovePdfState());

      emit(LoadedMovePdfState());
    } catch (e) {
      emit(InitialMovePdfState());
      emit(ErrorMovePdfState(error: e.toString()));
    }
  }

  Future<void> downloadPdf(List<MovementModel> movementList) async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMovePdfState());
      await MovementPdfRepo.movementPdfSave(movementList);
      emit(LoadedMovePdfState());
    } catch (e) {
      emit(ErrorMovePdfState(error: e.toString()));
    }
  }

  Future<void> downloadPdfFilter(String document, String folio) async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMovePdfState());
      ReportInventoryMoveModel dataReport;
      List<ReportInventoryMoveModel> dataReportList = [];
      MovementResponseModel movementResponse;
      List<MovementModel> movementList;
      List<String> documentList = [];
      List<int> folioList = [];
      Map<String, WarehouseModel> warehouseMap = {};
      Map<String, WarehouseModel> warehouseDestinyMap = {};
      Map<String, Map<String,ReportInventoryRowModel>> productMap = {};
      List<WarehouseModel> warehouseList;
      List<WarehouseModel> warehouseDestinyList;
      List<ProductModel> productList;
      List<int> warehouseIdList = [];
      List<int> warehouseDestinyIdList = [];
      List<String> productCodeList = [];
      List<ReportInventoryRowModel> productRowList = [];

      documentList = document.split(',');
      for (String element in folio.split(',')) {
        final numFolio = int.tryParse(element);
        if (numFolio != null) {
          folioList.add(numFolio);
        }
      }

      movementResponse = await MovementRepo().fetchMovements(
        filter: MovementFilterModel(
          initDate: DateTime(0),
          endDate: DateTime(0),
          warehouse: WarehouseModel.empty(),
          filterDate: false,
          document: documentList,
          folio: folioList,
        ),
        rangeMin: 0,
        rangeMax: 1000,
      );

      for (var move in movementResponse.movementList) {
        if (warehouseIdList.contains(move.warehouseId) == false &&
            move.concept != 7) {
          warehouseIdList.add(move.warehouseId);
        }
        if (warehouseDestinyIdList.contains(move.warehouseId) == false &&
            move.concept == 7) {
          warehouseDestinyIdList.add(move.warehouseId);
        }
        if (productCodeList.contains(move.code) == false) {
          productCodeList.add(move.code);
        }
      }

      warehouseList =
          await WarehousesRepo().fetchWarehouseListId(warehouseIdList);
      warehouseDestinyList =
          await WarehousesRepo().fetchWarehouseListId(warehouseDestinyIdList);
      productList = await ProductRepo().fetchProductListCode(productCodeList);

      for (var move in movementResponse.movementList) {
        if (warehouseList.where((x) => x.id == move.warehouseId).isNotEmpty &&
            move.concept != 7) {
          warehouseMap[move.id] =
              warehouseList.where((x) => x.id == move.warehouseId).first;
        }
        if (warehouseDestinyList
                .where((x) => x.id == move.warehouseId)
                .isNotEmpty &&
            move.concept == 7) {
          warehouseDestinyMap[move.id] =
              warehouseDestinyList.where((x) => x.id == move.warehouseId).first;
        }
        if (productMap.keys.contains(move.document)) {
          if (productMap[move.document].keys.contains(element)) {
            productMap[move.document].elementAt(index) = ReportInventoryRowModel.addProduct(
            reportInventoryRow: productMap[move.document]!,
            quantity: move.quantity,
          );
          }
          
        } else {
          productMap[move.document] = ReportInventoryRowModel(
            product: productList.where((x) => x.code == move.code).first,
            quantity: move.quantity,
          );
        }
      }

      productRowList 

      for (var move in movementResponse.movementList) {
        if (dataReportList.isEmpty) {
          dataReport = ReportInventoryMoveModel(
            warehouse: warehouseMap[move.id] ?? WarehouseModel.empty(),
            dateTime: move.time,
            document: move.document,
            productList: productMap[move.document] ?? [],
            warehouseDestiny:
                warehouseDestinyMap[move.id] ?? WarehouseModel.empty(),
            concept: ConceptMoveModel(
              id: move.concept,
              text: move.code,
              type: move.conceptType,
            ),
            folio: move.folio,
          );
        }
      }

      await InventoryPdfRepo.singleMove(dataReport);
      emit(LoadedMovePdfState());
    } catch (e) {
      emit(ErrorMovePdfState(error: e.toString()));
    }
  }
}

class MovementPdfForm extends Cubit<MovementPdfFormModel> {
  MovementPdfForm() : super(MovementPdfFormModel.empty());
}
