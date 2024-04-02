import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:axol_inventarios/modules/sale/sale_note/repository/sale_referral_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../inventory_/inventory/model/inventory_model.dart';
import '../../../../inventory_/inventory/model/inventory_move/concept_move_model.dart';
import '../../../../inventory_/inventory/repository/inventory_repo.dart';
import '../../../../inventory_/inventory/repository/warehouses_repo.dart';
import '../../../../inventory_/movements/model/movement_model.dart';
import '../../../../inventory_/movements/repository/movement_repo.dart';
import '../../../../inventory_/product/model/product_model.dart';
import '../../../../inventory_/product/repository/product_repo.dart';
import '../../../../user/model/user_mdoel.dart';
import '../../../../user/repository/user_repo.dart';
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
      List<MovementModel> movementList = [];
      MovementModel movement;
      UserModel user;
      List<ProductModel> productList;
      ProductModel product;
      List<String> codeList = [];
      String code;
      int folio;

      emit(InitialSaleNoteDeleteState());
      emit(LoadingSaleNoteCancelState());

      //Actualiza estado de nota de venta o remisión
      if (saleType == 0) {
        await SaleNoteRepo().cancelNote(saleNote);
      }
      if (saleType == 1) {
        await SaleReferralRepo().cancelReferral(saleNote);
      }

      //Consulta User
      user = await LocalUser().getLocalUser();

      //Consulta productos
      //Est se hace porque la lista de productos de sale note solo
      // contiene las claves.
      for (var element in saleNote.saleProduct) {
        code = element.product.code;
        codeList.add(code);
      }
      productList = await ProductRepo().fetchProductListCode(codeList);

      //Consulta lista de folios
      folio = await MovementRepo()
          .fetchAvailableFolio();

      //Itera lista de productos en saleNote
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

        //Agrega movimiento al hisotrial de movimientos
        product = productList.where((x) => x.code == saleProduct.product.code).first;
        movement = MovementModel(
          id: const Uuid().v4(),
          code: product.code,
          concept: 4,
          conceptType: 0,
          conceptName: ConceptMoveModel.conceptName4,
          description: product.description,
          document: saleNote.id.toString(),
          quantity: saleProduct.quantity,
          time: DateTime.now(),
          warehouseName: saleNote.warehouse.name,
          warehouseId: saleNote.warehouse.id,
          user: user.name,
          stock: inventory.stock,
          folio: folio,
        );
        movementList.add(movement);
      }

      //Inserta movimientos en base de datos
      await MovementRepo().insertMovemets(movementList);

      emit(CloseSaleNoteCancelState());
    } catch (e) {
      emit(InitialSaleNoteDeleteState());
      emit(ErrorSaleNoteCancelState(error: e.toString()));
    }
  }
}
