import 'package:axol_inventarios/modules/sale/sale_note/repository/sale_referral_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/inventory_model.dart';
import '../../../../inventory_/inventory/repository/inventory_repo.dart';
import '../../model/sale_note_model.dart';
import '../../repository/sale_note_repo.dart';
import 'salenote_cancel_state.dart';

class SaleNoteCancelCubit extends Cubit<SaleNoteCancelState> {
  SaleNoteCancelCubit() : super(InitialSaleNoteDeleteState());

  Future<void> load() async {
    try {
      emit(InitialSaleNoteDeleteState());
      emit(LoadedSaleNoteDeleteState());
    } catch (e) {
      emit(InitialSaleNoteDeleteState());
      emit(ErrorSaleNoteCancelState(error: e.toString()));
    }
  }

  Future<void> cancelSaleNote(SaleNoteModel saleNote, int saleType) async {
    try {
      InventoryModel? inventoryDB;
      InventoryModel inventory;
      emit(InitialSaleNoteDeleteState());
      emit(LoadingSaleNoteCancelState());
      if (saleType == 0) {
        await SaleNoteRepo().cancelNote(saleNote);
      }
      if (saleType == 1) {
        await SaleReferralRepo().cancelReferral(saleNote);
      }
      for (var saleProduct in saleNote.saleProduct) {
        inventoryDB = await InventoryRepo()
            .fetchRowByCode(saleProduct.product.code, saleNote.warehouse.name);
        inventory = inventoryDB ??
            InventoryModel.stockZero(
                saleProduct.product.code, saleNote.warehouse);
        inventory.stock = inventory.stock + saleProduct.quantity;
        if (inventoryDB == null) {
          await InventoryRepo().insertInventoryRow(inventory);
        } else {
          await InventoryRepo().updateInventoryRow(inventory);
        }
      }
      emit(CloseSaleNoteCancelState());
    } catch (e) {
      emit(InitialSaleNoteDeleteState());
      emit(ErrorSaleNoteCancelState(error: e.toString()));
    }
  }
}
