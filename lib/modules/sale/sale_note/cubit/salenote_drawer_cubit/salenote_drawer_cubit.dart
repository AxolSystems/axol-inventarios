import 'package:axol_inventarios/models/textfield_form_model.dart';
import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/sale/sale_note/cubit/salenote_drawer_cubit/salenote_drawer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../../inventory_/inventory/repository/warehouses_repo.dart';
import '../../../customer/model/customer_model.dart';
import '../../model/saelnote_add_form_model.dart';
import '../../../vendor/model/vendor_model.dart';
import '../../../customer/repository/customer_repo.dart';
import '../../../vendor/repository/vendor_repo.dart';

class SalenoteDrawerCubit extends Cubit<SalenoteDrawerState> {
  SalenoteDrawerCubit() : super(InitialState());

  static const String _pCustomer = SaleNoteAddFormModel.pCustomer;
  static const String _pVendor = SaleNoteAddFormModel.pVendor;
  static const String _pWarehouse = SaleNoteAddFormModel.pWarehouse;
  static const String _pValidation = TextfieldFormModel.pValidation;
  static const String _pCustomerModel = SaleNoteAddFormModel.pCustomerModel;
  static const String _pVendorModel = SaleNoteAddFormModel.pVendorModel;
  static const String _pWarehouseModel = SaleNoteAddFormModel.pWarehouseModel;

  Future<void> initial() async {
    try {
      emit(InitialState());
      emit(LoadingState());
      emit(LoadedState(modelMap: {}, response: []));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> change(SaleNoteAddFormModel salenoteForm, int keyElement) async {
    try {
      List<CustomerModel> customersDB;
      List<VendorModel> vendorsDB;
      List<WarehouseModel> warehouseDB;
      List<String> response = [];
      Map<int, dynamic> modelMap = {
        0: CustomerModel.empty(),
        1: VendorModel.empty(),
        2: WarehouseModel.empty(),
      };
      emit(const LoadingState());
      if (keyElement == -1) {
        //Validar todos
        customersDB =
            await CustomerRepo().fetchCustomersEq(salenoteForm.customerTf.value);
        vendorsDB = await VendorRepo().fetchVendorEq(salenoteForm.vendorTf.value);
        warehouseDB = await WarehousesRepo()
            .fetchWarehouseEq(salenoteForm.warehouseTf.value);
        if (customersDB.isNotEmpty) {
          if (customersDB.length > 1) {
            response.add(
                '$_pCustomer:$_pValidation:false/Hay más de un cliente con el mismo nombre');
          } else if (customersDB.length == 1) {
            response.add('$_pCustomer:$_pValidation:true/');
            response.add(_pCustomerModel);
            modelMap[0] = customersDB.first;
          }
        } else {
          response.add('$_pCustomer:$_pValidation:false/Dato inexistente');
        }
        if (vendorsDB.isNotEmpty) {
          if (vendorsDB.length > 1) {
            response.add(
                '$_pVendor:$_pValidation:false/Hay más de un vendedor con el mismo nombre');
          } else if (vendorsDB.length == 1) {
            response.add('$_pVendor:$_pValidation:true/');
            response.add(_pVendorModel);
            modelMap[1] = vendorsDB.first;
          }
        } else {
          response.add('$_pVendor:$_pValidation:false/Dato inexistente');
        }
        if (warehouseDB.isNotEmpty) {
          if (warehouseDB.length > 1) {
            response.add(
                '$_pWarehouse:$_pValidation:false/Hay más de un almacén con el mismo nombre');
          } else if (warehouseDB.length == 1) {
            response.add('$_pWarehouse:$_pValidation:true/');
            response.add(_pWarehouseModel);
            modelMap[2] = warehouseDB.first;
          }
        } else {
          response.add('$_pWarehouse:$_pValidation:false/Dato inexistente');
        }
      } else if (keyElement == 0) {
        //validar Customer
        customersDB =
            await CustomerRepo().fetchCustomersEq(salenoteForm.customerTf.value);
        if (customersDB.isNotEmpty) {
          if (customersDB.length > 1) {
            response.add(
                '$_pCustomer:$_pValidation:false/Hay más de un cliente con el mismo nombre');
            response.add(_pCustomerModel);
            modelMap[0] = CustomerModel.empty();
          } else if (customersDB.length == 1) {
            response.add('$_pCustomer:$_pValidation:true/');
            response.add(_pCustomerModel);
            modelMap[0] = customersDB.first;
          }
        } else {
          response.add('$_pCustomer:$_pValidation:false/Dato inexistente');
          response.add(_pCustomerModel);
          modelMap[0] = CustomerModel.empty();
        }
      } else if (keyElement == 1) {
        //Validar Vendor
        vendorsDB = await VendorRepo().fetchVendorEq(salenoteForm.vendorTf.value);
        if (vendorsDB.isNotEmpty) {
          if (vendorsDB.length > 1) {
            response.add(
                '$_pVendor:$_pValidation:false/Hay más de un vendedor con el mismo nombre');
            response.add(_pVendorModel);
            modelMap[1] = VendorModel.empty();
          } else if (vendorsDB.length == 1) {
            response.add('$_pVendor:$_pValidation:true/');
            response.add(_pVendorModel);
            modelMap[1] = vendorsDB.first;
          }
        } else {
          response.add('$_pVendor:$_pValidation:false/Dato inexistente');
          response.add(_pVendorModel);
          modelMap[1] = VendorModel.empty();
        }
      } else if (keyElement == 2) {
        //valdiar Warehouse
        warehouseDB = await WarehousesRepo()
            .fetchWarehouseEq(salenoteForm.warehouseTf.value);
        if (warehouseDB.isNotEmpty) {
          if (warehouseDB.length > 1) {
            response.add(
                '$_pWarehouse:$_pValidation:false/Hay más de un almacén con el mismo nombre');
            response.add(_pWarehouseModel);
            modelMap[2] = WarehouseModel.empty();
          } else if (warehouseDB.length == 1) {
            response.add('$_pWarehouse:$_pValidation:true/');
            response.add(_pWarehouseModel);
            modelMap[2] = warehouseDB.first;
          }
        } else {
          response.add('$_pWarehouse:$_pValidation:false/Dato inexistente');
          response.add(_pWarehouseModel);
          modelMap[2] = WarehouseModel.empty();
        }
      }
      emit(InitialState());
      emit(LoadedState(response: response, modelMap: modelMap));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
