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

  Future<void> downloadPdfFolio(int folio) async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMovePdfState());

      MovementResponseModel movementResponse;
      List<int> warehouseIdList = [];
      List<String> productCodeList = [];
      List<WarehouseModel> warehouseList;
      List<ProductModel> productList;
      ReportInventoryMoveModel dataReport = ReportInventoryMoveModel.empty();
      ProductModel product;
      WarehouseModel warehouse = WarehouseModel.empty();
      WarehouseModel warehouseDestiny = WarehouseModel.empty();

      //Obtiene los movimientos filtrados.
      movementResponse = await MovementRepo().fetchMovements(
        filter: MovementFilterModel(
          initDate: DateTime(0),
          endDate: DateTime(0),
          warehouse: WarehouseModel.empty(),
          filterDate: false,
          document: [],
          folio: [folio],
        ),
        rangeMin: 0,
        rangeMax: 1000,
      );

      //Enlista los almacenes y productos para despues muscarlos en sus bases de datos.
      for (var move in movementResponse.movementList) {
        if (warehouseIdList.contains(move.warehouseId) == false) {
          warehouseIdList.add(move.warehouseId);
        }
        if (productCodeList.contains(move.code) == false) {
          productCodeList.add(move.code);
        }
      }

      //Busca en la base de datos los almacenes y productos enlistados.
      warehouseList =
          await WarehousesRepo().fetchWarehouseListId(warehouseIdList);
      productList = await ProductRepo().fetchProductListCode(productCodeList);

      for (var move in movementResponse.movementList) {
        if (move.concept == 7 || move.concept == 58) {
          if (move.concept == 7 && dataReport.warehouseDestiny.id < 0) {
            warehouseDestiny =
                warehouseList.where((x) => x.id == move.warehouseId).first;
            dataReport = ReportInventoryMoveModel.transfer(
              warehouse: warehouse,
              dateTime: move.time,
              document: move.document,
              productList: [],
              warehouseDestiny: warehouseDestiny,
              concept: ConceptMoveModel(
                  text: ConceptMoveModel.conceptName58, id: 58, type: 1),
            );
          } else if (move.concept == 58 && dataReport.warehouse.id < 0) {
            warehouse =
                warehouseList.where((x) => x.id == move.warehouseId).first;
            dataReport = ReportInventoryMoveModel.transfer(
              warehouse: warehouse,
              dateTime: move.time,
              document: move.document,
              productList: [],
              warehouseDestiny: warehouseDestiny,
              concept: ConceptMoveModel(
                  text: ConceptMoveModel.conceptName58, id: 58, type: 1),
            );
          }
        } else if (warehouse.id < 0) {
          warehouse =
              warehouseList.where((x) => x.id == move.warehouseId).first;
          dataReport = ReportInventoryMoveModel.singleMove(
            warehouse: warehouse,
            dateTime: move.time,
            document: move.document,
            productList: [],
            concept: ConceptMoveModel(
              text: move.conceptName,
              id: move.concept,
              type: move.conceptType,
            ),
          );
        }
        product = productList.where((x) => x.code == move.code).first;
        dataReport = ReportInventoryMoveModel.addProduct(
          reportMove: dataReport,
          product: product,
          quantity: move.quantity,
        );
      }

      if (dataReport.concept.id == 58) {
        InventoryPdfRepo.transferPdf(dataReport);
      } else {
        await InventoryPdfRepo.singleMove(dataReport);
      }

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
      Map<String, Map<String, ReportInventoryRowModel>> productMap = {};
      Map<String, ReportInventoryMoveModel> dataReportMap = {};
      List<WarehouseModel> warehouseList;
      List<WarehouseModel> warehouseDestinyList;
      List<ProductModel> productList;
      List<int> warehouseIdList = [];
      List<int> warehouseDestinyIdList = [];
      List<String> productCodeList = [];
      List<ReportInventoryRowModel> productRowList = [];
      WarehouseModel warehouse;
      ProductModel product;

      documentList = document.split(',');
      if (documentList.length == 1 && documentList.single == '') {
        documentList = [];
      }
      for (String element in folio.split(',')) {
        final numFolio = int.tryParse(element);
        if (numFolio != null) {
          folioList.add(numFolio);
        }
      }

      //Obtiene los movimientos filtrados.
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

      //Enlista los almacenes y productos para despues muscarlos en sus bases de datos.
      for (var move in movementResponse.movementList) {
        if (warehouseIdList.contains(move.warehouseId) == false) {
          warehouseIdList.add(move.warehouseId);
        }
        if (productCodeList.contains(move.code) == false) {
          productCodeList.add(move.code);
        }
      }

      //Busca en la base de datos los almacenes y productos enlistados.
      warehouseList =
          await WarehousesRepo().fetchWarehouseListId(warehouseIdList);
      productList = await ProductRepo().fetchProductListCode(productCodeList);

      //Pasa cada movimiento a un map de RerportInventoryMoveModel, donde
      // los keys son los distintos documentos que se filtraron.
      for (var move in movementResponse.movementList) {
        if (warehouseList.where((x) => x.id == move.warehouseId).isNotEmpty) {
          warehouse =
              warehouseList.where((x) => x.id == move.warehouseId).first;
        } else {
          warehouse = WarehouseModel.empty();
        }
        if (productList.where((x) => x.code == move.code).isNotEmpty) {
          product = productList.where((x) => x.code == move.code).first;
        } else {
          product = ProductModel.empty();
        }

        if (move.concept != 7) {
          if (dataReportMap.keys.contains(move.document)) {
            dataReportMap[move.document] = ReportInventoryMoveModel.addProduct(
              reportMove: dataReportMap[move.document]!,
              product: product,
              quantity: move.quantity,
            );
          } else {
            dataReportMap[move.document] = ReportInventoryMoveModel(
              warehouse: warehouse,
              dateTime: move.time,
              document: move.document,
              productList: [
                ReportInventoryRowModel(
                  product: product,
                  quantity: move.quantity,
                )
              ],
              warehouseDestiny: WarehouseModel.empty(),
              concept: ConceptMoveModel(
                id: move.concept,
                text: move.conceptName,
                type: move.conceptType,
              ),
              folio: move.folio,
            );
          }
        } else {
          if (dataReportMap.keys.contains(move.document)) {
            dataReportMap[move.document] =
                ReportInventoryMoveModel.warehouseDestiny(
              reportMove: dataReportMap[move.code]!,
              warehouseDestiny: warehouse,
            );
          } else {
            dataReportMap[move.document] = ReportInventoryMoveModel(
              warehouse: WarehouseModel.empty(),
              dateTime: move.time,
              document: move.document,
              productList: [
                ReportInventoryRowModel(
                  product: product,
                  quantity: move.quantity,
                )
              ],
              warehouseDestiny: warehouse,
              concept: ConceptMoveModel(
                id: move.concept,
                text: move.conceptName,
                type: move.conceptType,
              ),
              folio: move.folio,
            );
          }
        }
      }

      if (dataReportMap.keys.length == 1) {
        dataReport = dataReportMap.values.single;
        if (dataReport.concept.id == 58) {
          InventoryPdfRepo.transferPdf(dataReport);
        } else {
          await InventoryPdfRepo.singleMove(dataReport);
        }
      }

      emit(LoadedMovePdfState());
    } catch (e) {
      emit(ErrorMovePdfState(error: e.toString()));
    }
  }
}

class MovementPdfForm extends Cubit<MovementPdfFormModel> {
  MovementPdfForm() : super(MovementPdfFormModel.empty());
}
