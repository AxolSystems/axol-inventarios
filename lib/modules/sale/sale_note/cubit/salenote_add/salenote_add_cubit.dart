import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/product/repository/product_repo.dart';
import 'package:axol_inventarios/modules/sale/vendor/model/vendor_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/inventory_model.dart';
import '../../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../../inventory_/inventory/repository/inventory_repo.dart';
import '../../../../inventory_/inventory/repository/warehouses_repo.dart';
import '../../../../inventory_/product/model/product_model.dart';
import '../../../customer/model/customer_model.dart';
import '../../../customer/repository/customer_repo.dart';
import '../../../vendor/repository/vendor_repo.dart';
import '../../model/saelnote_add_form_model.dart';
import '../../model/salenote_row_form_model.dart';
import '../../repository/sale_note_repo.dart';
import 'salenote_add_state.dart';

class SaleNoteAddCubit extends Cubit<SaleNoteAddState> {
  SaleNoteAddCubit() : super(InitialSaleNoteAddState());

  Future<void> initLoad(SaleNoteAddFormModel form) async {
    SaleNoteAddFormModel upForm = form;
    int availableId = -1;
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      availableId = await SaleNoteRepo().fetchAvailableId();
      upForm.id = availableId;
      upForm.productList = [
        SaleNoteRowFormModel.empty(),
        SaleNoteRowFormModel.empty()
      ];
      emit(const LoadedSaleNoteAddState(rowFormList: []));
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      emit(const LoadedSaleNoteAddState(rowFormList: []));
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
      emit(const LoadedSaleNoteAddState(rowFormList: []));
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
      } else {
        upForm.vendorTf.validation = ValidationFormModel(
            isValid: false, errorMessage: form.emInvalidData);
      }
      emit(const LoadedSaleNoteAddState(rowFormList: []));
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
      emit(const LoadedSaleNoteAddState(rowFormList: []));
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> validateCell(
      SaleNoteAddFormModel form, String key, int index) async {
    SaleNoteRowFormModel row = form.productList[index];
    InventoryModel? inventoryRow;
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
          inventoryRow =
              await InventoryRepo().fetchRowByCode(code, inventoryName);
          if (inventoryRow == null || quantity > inventoryRow.stock) {
            row.quantity.validation =
                ValidationFormModel.falseValid(row.emNotStock);
          } else {
            productDB =
                await ProductRepo().fetchProductByCode(inventoryRow.code);
            row.quantity.validation = ValidationFormModel.trueValid();
            row.productCode.validation = ValidationFormModel.trueValid();
            row.quantity.value = quantity.toString();
            row.description = productDB?.description ?? '';
          }
        } else {
          row.quantity.validation = ValidationFormModel.trueValid();
          row.quantity.value = quantity.toString();
        }
      }
      if (key == row.keyProduct) {
        quantity ??= 0;
        inventoryRow =
            await InventoryRepo().fetchRowByCode(code, inventoryName);
        if (inventoryRow == null || quantity > inventoryRow.stock) {
          row.productCode.validation =
              ValidationFormModel.falseValid(row.emNotStock);
          row.description = '';
        } else {
          productDB = await ProductRepo().fetchProductByCode(inventoryRow.code);
          row.productCode.validation = ValidationFormModel.trueValid();
          row.description = productDB?.description ?? '';
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
      emit(const LoadedSaleNoteAddState(rowFormList: []));
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> validateAllList(SaleNoteAddFormModel form) async {
    InventoryModel? inventoryRow;
    double? quantity;
    String code;
    ProductModel? productDB;
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
          productDB = await ProductRepo().fetchProductByCode(inventoryRow.code);
          row.quantity.validation = ValidationFormModel.trueValid();
          row.productCode.validation = ValidationFormModel.trueValid();
          row.quantity.value = quantity.toString();
          row.description = productDB?.description ?? '';
        } else {
          row.quantity.validation =
              ValidationFormModel.falseValid(row.emNotStock);
          row.productCode.validation =
              ValidationFormModel.falseValid(row.emNotStock);
          row.description = '';
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
    }
  }
}
