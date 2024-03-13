import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/cubit/warehouse_stream_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_stream_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../../models/validation_form_model.dart';
import '../../repository/warehouses_repo.dart';
import 'warehouse_setting_state.dart';

/*class WarehouseSettingCubit extends Cubit<WarehouseSettingState> {
  WarehouseSettingCubit() : super(InitialState());

  /*List<ValidationFormModel> validationChange(
      TextfieldModel textfieldId,
      TextfieldModel textfieldName,
      String? userSelected,
      List<ValidationFormModel> currentValidation,
      int elementToValidate) {
    List<ValidationFormModel> validationList = [];
    final ValidationFormModel validationTrue =
        ValidationFormModel(isValid: true, errorMessage: '');

    for (var element in currentValidation) {
      validationList.add(element);
    }

    if (elementToValidate == 0 || elementToValidate == -1) {
      if (textfieldId.text == '') {
        validationList[0] =
            ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
      } else {
        validationList[0] = validationTrue;
      }
    }

    if (elementToValidate == 1 || elementToValidate == -1) {
      if (textfieldId.text == '') {
        validationList[1] =
            ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
      } else {
        validationList[1] = validationTrue;
      }
    }

    if (elementToValidate == 2 || elementToValidate == -1) {
      if (userSelected == null) {
        validationList[2] = ValidationFormModel(
            isValid: false,
            errorMessage: 'Seleccine a un encargado de almacén');
      } else {
        validationList[2] = validationTrue;
      }
    }

    return validationList;
  }*/

  Future<void> initialToAdd() async {
    try {
      TextfieldModel initTextfield = TextfieldModel(text: '', position: 0);
      List<ValidationFormModel> validationList = [];
      for (int i = 0; i < 3; i++) {
        validationList
            .add(ValidationFormModel(isValid: true, errorMessage: ''));
      }
      emit(InitialState());
      emit(const EditState());
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> change() async {
    try {
      emit(InitialState());
      emit(const EditState());
    } catch (e) {
      emit(ErrorState(error: 'Error en WarehouseSettingCubit.change(): $e'));
    }
  }

  Future<bool> add(WarehouseStreamModel warehouseStream) async {
    try {
      WarehouseModel? warehouseDB;
      WarehouseModel warehouse;
      bool isExist = false;
      final List<bool> validationList = [
        warehouseStream.dropdownManager.validation.isValid,
        warehouseStream.textfieldId.validation.isValid,
        warehouseStream.textfieldName.validation.isValid,
      ];
      final bool finalValidation = !validationList.contains(false);
      emit(InitialState());
      emit(LoadingState());
      if (warehouseStream.textfieldId.text != '') {
        warehouseDB = await WarehousesRepo()
            .fetchWarehouse(int.parse(warehouseStream.textfieldId.text));
      }
      if (finalValidation && warehouseDB == null) {
        //print('entro');
        warehouse = WarehouseModel(
          id: int.parse(warehouseStream.textfieldId.text),
          name: warehouseStream.textfieldName.text,
          retailManager: warehouseStream.dropdownManager.value,
        );
        await WarehousesRepo().insertWarehouse(warehouse);
        emit(LoadedState());
      } else {
        if (warehouseDB != null) {
          isExist = true;
        }
        emit(const EditState());
      }
      return isExist;
    } catch (e) {
      emit(ErrorState(error: 'Error en WarehouseSettingCubit.add(): $e'));
      return false;
    }
  }

  Future<void> edit(WarehouseStreamModel warehouseStream) async {
    try {
      WarehouseModel warehouse = WarehouseModel(
        id: int.parse(warehouseStream.textfieldId.text),
        name: warehouseStream.textfieldName.text,
        retailManager: warehouseStream.dropdownManager.value,
      );
      final List<bool> validationList = [
        warehouseStream.dropdownManager.validation.isValid,
        warehouseStream.textfieldId.validation.isValid,
        warehouseStream.textfieldName.validation.isValid,
      ];
      final bool finalValidation = !validationList.contains(false);
      emit(InitialState());
      emit(LoadingState());
      if (finalValidation) {
        await WarehousesRepo().updateWarehouse(warehouse);
        emit(LoadedState());
      } else {
        emit(const EditState());
      }
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> remove(int id) async {
    try {
      emit(InitialState());
      emit(RemoveLoadingState());
      await WarehousesRepo().deleteWarehouse(id);
      emit(RemoveLoadedState());
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> openAlert(int id) async {
    try {
      emit(InitialState());
      emit(RemoveAlertState(id: id));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}*/
