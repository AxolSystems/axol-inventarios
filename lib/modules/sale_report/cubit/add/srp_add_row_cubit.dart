import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/inventory_row_model.dart';
import '../../model/salereport_row_model.dart';
import '../../model/srp_add_row_form_model.dart';

enum SrpAddRowState { intital, loading, load, error, save }

enum SrpAddRowSubtState { add, edit }

class SrpAddRowCubit extends Cubit<SrpAddRowState> {
  SrpAddRowCubit() : super(SrpAddRowState.intital);

  Future<void> initLoad(
      SrpAddRowFormModel form, String initValue) async {
    try {
      emit(SrpAddRowState.intital);
      emit(SrpAddRowState.loading);

      emit(SrpAddRowState.load);
    } catch (e) {
      form.errorMessageQty = e.toString();
      emit(SrpAddRowState.error);
    }
  }

  Future<void> load(SrpAddRowFormModel form) async {
    try {
      emit(SrpAddRowState.intital);
      emit(SrpAddRowState.loading);
      emit(SrpAddRowState.load);
    } catch (e) {
      form.errorMessageQty = e.toString();
      emit(SrpAddRowState.error);
    }
  }

  Future<void> save(SrpAddRowFormModel form) async {
    try {
      emit(SrpAddRowState.intital);
      emit(SrpAddRowState.loading);
      final qty = double.tryParse(form.qtyCtrl.text);
      final unitPrice = double.tryParse(form.unitPriceCtrl.text);
      bool isQtyValid = true;
      bool isPriceValid = true;

      if (qty == null && isQtyValid) {
        form.errorMessageQty = 'Seleccione una cantidad.';
        isQtyValid = false;
      } else if (qty > form.stock && isQtyValid) {
        form.errorMessageQty = 'La cantidad no puede ser mayor al stock.';
        isQtyValid = false;
      } else if (qty <= 0 && isQtyValid) {
        form.errorMessageQty = 'La cantidad debe ser mayor a cero.';
        isQtyValid = false;
      }
      if (isQtyValid) {
        form.errorMessageQty = null;
      }

      if (unitPrice == null && isPriceValid) {
        form.errorMessagePrice = 'Seleccione un precio valido';
        isPriceValid = false;
      }
      if (isPriceValid) {
        form.errorMessagePrice = null;
      }

      emit(SrpAddRowState.save);
      emit(SrpAddRowState.load);
    } catch (e) {
      form.errorMessageQty = e.toString();
      emit(SrpAddRowState.error);
    }
  }
}

class SrpAddRowForm extends Cubit<SrpAddRowFormModel> {
  final SaleReportRowModel? reportRow;
  final InventoryRowModel? inventoryRow;
  SrpAddRowForm([this.reportRow, this.inventoryRow])
      : super((reportRow == null || inventoryRow == null)
            ? SrpAddRowFormModel.empty()
            : SrpAddRowFormModel.set(
                reportRow: reportRow, inventoryRow: inventoryRow));
}
