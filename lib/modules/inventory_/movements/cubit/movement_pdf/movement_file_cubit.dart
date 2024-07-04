import 'package:axol_inventarios/modules/inventory_/inventory/model/report_multimove/report_multimove_subrow_model.dart';
import 'package:axol_inventarios/modules/inventory_/movements/model/movement_filter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory/model/inventory_move/concept_move_model.dart';
import '../../../inventory/model/report_inventory_move_model.dart';
import '../../../inventory/model/report_multimove/report_multimove_model.dart';
import '../../../inventory/model/report_multimove/report_mutlimove_row_model.dart';
import '../../../inventory/model/warehouse_model.dart';
import '../../../inventory/repository/inventory_file_repo.dart';
import '../../../inventory/repository/warehouses_repo.dart';
import '../../../product/model/product_model.dart';
import '../../../product/repository/product_repo.dart';
import '../../model/movement_model.dart';
import '../../model/movement_pdf_form_model.dart';
import '../../model/movement_response_model.dart';
import '../../repository/movement_files_repo.dart';
import '../../repository/movement_repo.dart';
import 'movement_file_state.dart';

class MovementFileCubit extends Cubit<MovementPdfState> {
  MovementFileCubit() : super(InitialMovePdfState());

  Future<void> initLoad(MovementFileFormModel form) async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMoveFileState());
      List<WarehouseModel> warehouseList;

      warehouseList = await WarehousesRepo().fetchAllWarehouses();
      warehouseList.sort((a, b) => a.id.compareTo(b.id));
      form.warehouseList = warehouseList;

      emit(LoadedMoveFileState());
    } catch (e) {
      emit(InitialMovePdfState());
      emit(ErrorMoveFileState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMoveFileState());

      emit(LoadedMoveFileState());
    } catch (e) {
      emit(InitialMovePdfState());
      emit(ErrorMoveFileState(error: e.toString()));
    }
  }

  Future<void> downloadPdf(List<MovementModel> movementList) async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMoveFileState());
      await MovementPdfRepo.movementPdfSave(movementList);
      emit(LoadedMoveFileState());
    } catch (e) {
      emit(ErrorMoveFileState(error: e.toString()));
    }
  }

  Future<void> downloadPdfFolio(int folio) async {
    bool isError = false;
    String messangeError = '';

    try {
      emit(InitialMovePdfState());
      emit(LoadingMoveFileState());

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
          concept: [],
          folio: [folio],
        ),
        rangeMin: 0,
        rangeMax: 1000,
      );

      if (movementResponse.count <= 0) {
        isError = true;
        messangeError = 'Agrege folio existente';
        return;
      }

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

      emit(LoadedMoveFileState());
    } catch (e) {
      emit(ErrorMoveFileState(error: e.toString()));
    } finally {
      if (isError == true) {
        emit(ErrorMoveFileState(error: messangeError));
      }
    }
  }

  Future<void> downloadPdfDocument({
    required String document,
    required String concept,
    bool? isFilterTime,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    bool isError = false;
    String messangeError = '';

    try {
      emit(InitialMovePdfState());
      emit(LoadingMoveFileState());

      MovementResponseModel movementResponse;
      List<int> warehouseIdList = [];
      List<String> productCodeList = [];
      List<WarehouseModel> warehouseList;
      List<ProductModel> productList;
      ReportMultimoveModel dataReport = ReportMultimoveModel.empty();
      ReportMultimoveSubrowModel subRow;
      List<int> conceptList = [];
      bool isFilterConcept = false;

      for (var element in concept.split(',')) {
        final conceptInt = int.tryParse(element);
        if (conceptInt != null) {
          conceptList.add(conceptInt);
          isFilterConcept = true;
        }
      }

      //Obtiene los movimientos filtrados.
      movementResponse = await MovementRepo().fetchMovements(
        filter: MovementFilterModel(
          initDate: startTime ?? DateTime(0),
          endDate: endTime ?? DateTime(0),
          warehouse: WarehouseModel.empty(),
          filterDate: isFilterTime ?? false,
          document: [document],
          concept: conceptList,
          folio: [],
        ),
        rangeMin: 0,
        rangeMax: 1000,
        isFilterConcept: isFilterConcept,
      );

      if (movementResponse.count <= 0) {
        isError = true;
        messangeError = 'No hay datos';
        return;
      }

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

      //Llena los datos del documento
      for (var move in movementResponse.movementList) {
        //Agrega datos del encaezado
        if (dataReport.startTime.year == 0) {
          dataReport = ReportMultimoveModel.changeDoc(
            reportMultimove: dataReport,
            document: document,
          );
          dataReport = ReportMultimoveModel.changeStartTime(
            reportMultimove: dataReport,
            startTime: move.time,
          );
          dataReport = ReportMultimoveModel.changeEndTime(
            reportMultimove: dataReport,
            endTime: move.time,
          );
        } else if (dataReport.startTime.millisecondsSinceEpoch >
            move.time.millisecondsSinceEpoch) {
          dataReport = ReportMultimoveModel.changeStartTime(
            reportMultimove: dataReport,
            startTime: move.time,
          );
        } else if (dataReport.endTime.millisecondsSinceEpoch <
            move.time.millisecondsSinceEpoch) {
          dataReport = ReportMultimoveModel.changeEndTime(
            reportMultimove: dataReport,
            endTime: move.time,
          );
        }

        //Declara subrow de indice
        subRow = ReportMultimoveSubrowModel(
          concept: ConceptMoveModel(
            id: move.concept,
            text: move.conceptName,
            type: move.conceptType,
          ),
          dateTime: move.time,
          document: move.document,
          folio: move.folio,
          quantity: move.quantity,
        );

        //Captura subrow de indicie
        if (dataReport.rowList
            .where((x) => x.product.code == move.code)
            .isEmpty) {
          dataReport = ReportMultimoveModel.addRow(
            reportMultimove: dataReport,
            row: ReportMultimoveRowModel(
              product: productList.where((x) => x.code == move.code).first,
              warehouse:
                  warehouseList.where((x) => x.id == move.warehouseId).first,
              subrowList: [subRow],
            ),
          );
        } else {
          for (int i = 0; dataReport.rowList.length > i; i++) {
            if (dataReport.rowList[i].product.code == move.code) {
              dataReport.rowList[i] = ReportMultimoveRowModel.addSubrow(
                row: dataReport.rowList[i],
                subrow: subRow,
              );
            }
          }
        }
      }

      //Descarga pdf
      InventoryPdfRepo.multiMove(dataReport);

      emit(LoadedMoveFileState());
    } catch (e) {
      emit(ErrorMoveFileState(error: e.toString()));
    } finally {
      if (isError == true) {
        emit(ErrorMoveFileState(error: messangeError));
      }
    }
  }

  Future<void> csvMove(MovementFileFormModel form) async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMoveFileState());
      MovementResponseModel movementResponse;
      List<MovementModel> movementList = [];

      movementResponse = await MovementRepo().fetchMoveToDown(
        warehouseId: form.warehouseSelect,
        input: form.input,
        output: form.output,
        startTime: form.startTimeMoves,
        endTime: form.endTimeMoves,
      );
      movementList = movementResponse.movementList;

      await MovementCsvRepo.movementCsvSave(movementList);

      emit(LoadedMoveFileState());
    } catch (e) {
      emit(InitialMovePdfState());
      emit(ErrorMoveFileState(error: e.toString()));
    }
  }
}

class MovementFileForm extends Cubit<MovementFileFormModel> {
  MovementFileForm() : super(MovementFileFormModel.empty());
}
