import 'package:axol_inventarios/models/inventory_row_model.dart';
import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/product/repository/product_repo.dart';
import 'package:axol_inventarios/modules/sale/vendor/model/vendor_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../inventory_/inventory/model/inventory_model.dart';
import '../../../../inventory_/inventory/model/inventory_move/concept_move_model.dart';
import '../../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../../inventory_/inventory/repository/inventory_repo.dart';
import '../../../../inventory_/inventory/repository/warehouses_repo.dart';
import '../../../../inventory_/movements/model/movement_model.dart';
import '../../../../inventory_/movements/repository/movement_repo.dart';
import '../../../../inventory_/product/model/product_model.dart';
import '../../../../user/repository/user_repo.dart';
import '../../../customer/model/customer_model.dart';
import '../../../customer/repository/customer_repo.dart';
import '../../../vendor/repository/vendor_repo.dart';
import '../../model/saelnote_add_form_model.dart';
import '../../model/sale_note_model.dart';
import '../../model/sale_product_model.dart';
import '../../model/salenote_row_form_model.dart';
import '../../repository/sale_note_repo.dart';
import '../../repository/sale_referral_repo.dart';
import 'salenote_add_state.dart';

class SaleNoteAddCubit extends Cubit<SaleNoteAddState> {
  SaleNoteAddCubit() : super(InitialSaleNoteAddState());

  Future<void> initLoad(SaleNoteAddFormModel form, int saleType) async {
    SaleNoteAddFormModel upForm = form;
    int availableId = -1;
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      if (saleType == 0) {
        availableId = await SaleNoteRepo().fetchAvailableId();
      }
      if (saleType == 1) {
        availableId = await SaleReferralRepo().fetchAvailableId();
      }
      upForm.id = availableId;
      upForm.productList = [SaleNoteRowFormModel.empty()];
      emit(LoadedSaleNoteAddState());
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      emit(LoadedSaleNoteAddState());
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> fetchCustomer(String find, SaleNoteAddFormModel form) async {
    SaleNoteAddFormModel upForm = form;
    List<CustomerModel> customerList;
    List<String> findSplit;
    String upFind = find;
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      find = find.replaceAll(' ', '');
      findSplit = find.split('-');
      if (findSplit.isNotEmpty) {
        upFind = findSplit.first;
      }
      customerList = await CustomerRepo().fetchCustomersIlike(upFind);
      if (customerList.length == 1) {
        upForm.customer = customerList.first;
        upForm.customerTf.validation = ValidationFormModel.trueValid();
        upForm.customerTf.value =
            '${customerList.first.id} - ${customerList.first.name}';
      } else {
        upForm.customer = CustomerModel.empty();
        upForm.customerTf.validation = ValidationFormModel(
            isValid: false, errorMessage: form.emInvalidData);
      }
      emit(LoadedSaleNoteAddState());
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> fetchVendor(String find, SaleNoteAddFormModel form) async {
    SaleNoteAddFormModel upForm = form;
    List<VendorModel> vendorList;
    List<String> findSplit;
    String upFind = find;
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      find = find.replaceAll(' ', '');
      findSplit = find.split('-');
      if (findSplit.isNotEmpty) {
        upFind = findSplit.first;
      }
      vendorList = await VendorRepo().fetchVendorIlike(upFind);
      if (vendorList.length == 1) {
        upForm.vendorTf.validation = ValidationFormModel.trueValid();
        upForm.vendorTf.value =
            '${vendorList.first.id} - ${vendorList.first.name}';
        upForm.vendor = vendorList.first;
      } else {
        upForm.vendorTf.validation = ValidationFormModel(
            isValid: false, errorMessage: form.emInvalidData);
      }
      emit(LoadedSaleNoteAddState());
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> fetchWarehouse(String find, SaleNoteAddFormModel form) async {
    SaleNoteAddFormModel upForm = form;
    List<WarehouseModel> warehouseList;
    List<String> findSplit;
    String upFind = find;
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      find = find.replaceAll(' ', '');
      findSplit = find.split('-');
      if (findSplit.isNotEmpty) {
        upFind = findSplit.first;
      }
      warehouseList = await WarehousesRepo().fetchWarehouseIlike(upFind);
      if (warehouseList.length == 1) {
        upForm.warehouseTf.validation = ValidationFormModel.trueValid();
        upForm.warehouseTf.value =
            '${warehouseList.first.id} - ${warehouseList.first.name}';
        await validateAllList(upForm);
      } else {
        upForm.warehouseTf.validation = ValidationFormModel(
            isValid: false, errorMessage: form.emInvalidData);
      }
      emit(LoadedSaleNoteAddState());
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> validateCell(
      SaleNoteAddFormModel form, String key, int index) async {
    SaleNoteRowFormModel row = form.productList[index];
    InventoryModel inventoryRow;
    ProductModel? productDB;
    final String inventoryName = form.warehouseTf.validation.isValid
        ? form.warehouseTf.value.split(' - ').last
        : '';
    final code = row.productCode.value;
    double? quantity = double.tryParse(row.quantity.value);
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      if (key == row.keyQuantity) {
        if (row.quantity.value == '') {
          row.quantity.value = '0';
          quantity = 0;
        }
        if (quantity == null) {
          row.quantity.validation =
              ValidationFormModel.falseValid(row.emInvalidData);
        } else if (code != '') {
          print('flag1');
          inventoryRow =
              await InventoryRepo().fetchRowByCode(code, inventoryName) ??
                  InventoryModel.empty();

          if (inventoryRow == null || quantity > inventoryRow.stock) {
            print(inventoryRow.code);
            print(inventoryRow.id);
            print(inventoryRow.name);
            print(inventoryRow.retailManager);
            print(inventoryRow.stock);
            row.quantity.validation =
                ValidationFormModel.falseValid(row.emNotStock);
          } else {
            productDB = await ProductRepo().fetchProduct(inventoryRow.code);
            row.quantity.validation = ValidationFormModel.trueValid();
            row.quantity.value = quantity.toString();
            row.productCode.validation = ValidationFormModel.trueValid();
            row.product = productDB ?? ProductModel.empty();
          }
        } else {
          row.quantity.validation = ValidationFormModel.trueValid();
          row.quantity.value = quantity.toString();
        }
      }
      if (key == row.keyProduct) {
        quantity ??= 0;
        print('flag2');
        inventoryRow =
            await InventoryRepo().fetchRowByCode(code, inventoryName) ??
                InventoryModel.empty();
        print('flag2.5');
        if (inventoryRow == null || quantity > inventoryRow.stock) {
          row.productCode.validation =
              ValidationFormModel.falseValid(row.emNotStock);
          row.product = ProductModel.empty();
        } else {
          productDB = await ProductRepo().fetchProduct(inventoryRow.code);
          row.productCode.validation = ValidationFormModel.trueValid();
          row.product = productDB ?? ProductModel.empty();
        }
      }
      if (key == row.keyPrice) {
        if (row.unitPrice.value == '') {
          row.unitPrice.value = '0';
        }
        if (double.tryParse(row.unitPrice.value) == null) {
          row.unitPrice.validation =
              ValidationFormModel.falseValid(row.emInvalidData);
        } else {
          row.unitPrice.validation = ValidationFormModel.trueValid();
          row.unitPrice.value = double.parse(row.unitPrice.value).toString();
        }
      }
      form.productList[index] = row;
      emit(LoadedSaleNoteAddState());
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<ValidationFormModel> validateAllList(SaleNoteAddFormModel form) async {
    InventoryModel? inventoryRow;
    double? quantity;
    String code;
    ProductModel? productDB;
    Map<String, double> inventoryMap = {};
    ValidationFormModel validationForm = ValidationFormModel.trueValid();
    final String inventoryName = form.warehouseTf.validation.isValid
        ? form.warehouseTf.value.split(' - ').last
        : '';

    for (int i = 0; i < form.productList.length; i++) {
      var row = form.productList[i];
      code = row.productCode.value;
      quantity = double.tryParse(row.quantity.value);

      if (quantity != null && row.productCode.value != '') {
        inventoryRow =
            await InventoryRepo().fetchRowByCode(code, inventoryName);
        if (inventoryRow != null && quantity < inventoryRow.stock) {
          productDB = await ProductRepo().fetchProduct(inventoryRow.code);
          row.quantity.validation = ValidationFormModel.trueValid();
          row.productCode.validation = ValidationFormModel.trueValid();
          row.quantity.value = quantity.toString();
          row.product = productDB ?? ProductModel.empty();
        } else {
          row.quantity.validation =
              ValidationFormModel.falseValid(row.emNotStock);
          row.productCode.validation =
              ValidationFormModel.falseValid(row.emNotStock);
          row.product = ProductModel.empty();
        }
      } else if (row.productCode.value == '') {
        row.quantity.validation = ValidationFormModel.trueValid();
        row.quantity.value = quantity.toString();
      } else {
        row.quantity.validation =
            ValidationFormModel.falseValid(row.emInvalidData);
      }

      if (double.tryParse(row.unitPrice.value) == null) {
        row.unitPrice.validation =
            ValidationFormModel.falseValid(row.emInvalidData);
      } else {
        row.unitPrice.validation = ValidationFormModel.trueValid();
        row.unitPrice.value = double.parse(row.unitPrice.value).toString();
      }
      form.productList[i] = row;

      final stockInvMap = inventoryMap[row.product.code] ?? 0;
      final stockRow = double.tryParse(row.quantity.value) ?? 0;
      final stockDB = inventoryRow?.stock ?? 0;
      inventoryMap[row.product.code] = stockInvMap + stockRow;
      if (inventoryMap[row.product.code]! > stockDB) {
        validationForm = ValidationFormModel.falseValid('Stock insuficiente');
      }
    }

    return validationForm;
  }

  Future<void> save(SaleNoteAddFormModel form, int saleType) async {
    bool validSave = true;
    String errorMessage = '';
    ValidationFormModel validationForm;
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      await fetchCustomer(form.customerTf.value, form);
      print('Cargando Cliente');
      emit(LoadingSaleNoteAddState());
      await fetchVendor(form.vendorTf.value, form);
      print('Cargando vendedor');
      emit(LoadingSaleNoteAddState());
      await fetchWarehouse(form.warehouseTf.value, form);
      print('Cargando almacén');
      emit(LoadingSaleNoteAddState());
      validationForm = await validateAllList(form);
      print('Validando');
      emit(LoadingSaleNoteAddState());
      form.productList.removeWhere((x) => x.quantity.value == '0');
      if (form.customerTf.validation.isValid == false) {
        validSave = false;
        errorMessage =
            'Error en cliente: ${form.customerTf.validation.errorMessage}';
        return;
      }
      if (form.vendorTf.validation.isValid == false) {
        validSave = false;
        errorMessage =
            'Error en vendedor: ${form.vendorTf.validation.errorMessage}';
        return;
      }
      if (form.warehouseTf.validation.isValid == false) {
        validSave = false;
        errorMessage =
            'Error en almacén: ${form.warehouseTf.validation.errorMessage}';
        return;
      }
      for (int i = 0; i < form.productList.length; i++) {
        final row = form.productList[i];
        if (row.quantity.validation.isValid == false ||
            row.productCode.validation.isValid == false ||
            row.unitPrice.validation.isValid == false) {
          validSave = false;
          errorMessage = 'Error en los datos de los productos.';
          return;
        }
        if (row.productCode.value == '') {
          validSave = false;
          errorMessage = 'Campo de producto vacío.';
          form.productList[i].productCode.validation = ValidationFormModel(
              isValid: false, errorMessage: row.emInvalidData);
          return;
        }
      }
      if (form.productList.isEmpty) {
        validSave = false;
        errorMessage = 'Agregue al menos un producto.';
        return;
      }
      if (validationForm.isValid == false) {
        validSave = false;
        errorMessage = validationForm.errorMessage;
        return;
      }
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    } finally {
      SaleNoteModel saleNote = SaleNoteModel(
        id: form.id,
        customer: form.customer,
        date: form.dateTime,
        total: form.total,
        warehouse: form.warehouse,
        vendor: form.vendor,
        note: form.note,
        status: 1,
        saleProduct: SaleProductModel.rowToSale(form.productList),
      );
      List<InventoryModel> inventoryList = [];
      InventoryModel inventory;
      InventoryModel? inventoryDB;
      double stock;
      Map<String, double> inventoryMap = {};
      List<MovementModel> movementList = [];
      MovementModel movement;

      if (validSave) {
        for (var row in form.productList) {
          inventoryDB = await InventoryRepo()
              .fetchRowByCode(row.product.code, form.warehouse.name);

          if (inventoryDB != null) {
            final stockRow = double.tryParse(row.quantity.value) ?? 0;
            final stockMap = inventoryMap[row.product.code] ?? 0;
            inventoryMap[row.product.code] = stockMap + stockRow;
            stock = inventoryDB.stock - inventoryMap[row.product.code]!;
            if (stock < 0) {
              throw Exception('Stock no puede ser menor a cero');
            }

            inventory = InventoryModel(
              code: row.product.code,
              id: const Uuid().v4(),
              name: form.warehouse.name,
              retailManager: form.warehouse.retailManager,
              stock: stock,
            );
            inventoryList.add(inventory);

            final user = await LocalUser().getLocalUser();
            final int folio = await MovementRepo().fetchAvailableFolio();

            movement = MovementModel(
              id: const Uuid().v4(),
              code: row.product.code,
              concept: 51,
              conceptType: 1,
              description: row.product.description,
              document: form.id.toString(),
              quantity: stockRow,
              time: form.dateTime,
              warehouseName: form.warehouse.name,
              user: user.name,
              stock: stock,
              folio: folio,
              conceptName: ConceptMoveModel.sale,
              warehouseId: form.warehouse.id,
            );
            movementList.add(movement);
          } else {
            throw Exception('Stock no puede ser menor a cero');
          }
        }
        await InventoryRepo().updateInventory(inventoryList);
        await MovementRepo().insertMovemets(movementList);
        if (saleType == 0) {
          await SaleNoteRepo().insert(saleNote);
        }
        if (saleType == 1) {
          await SaleReferralRepo().insert(saleNote);
        }

        emit(SavedNoteAddState(saleNote, saleNote.saleProduct, saleType));
      } else {
        emit(ErrorSaleNoteAddState(error: errorMessage));
      }
    }
  }
}
