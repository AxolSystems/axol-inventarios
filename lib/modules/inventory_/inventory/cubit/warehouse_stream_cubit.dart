import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_model.dart';
import '../model/warehouse_stream_model.dart';

/*class WarehouseStreamCubit extends Cubit<WarehouseStreamModel> {
  WarehouseStreamModel? warehouseStream;
  WarehouseStreamCubit({this.warehouseStream})
      : super(warehouseStream ?? WarehouseStreamModel.initial());

  WarehouseStreamModel _validId(WarehouseStreamModel warehouseStream) {
    WarehouseStreamModel newWarehouseStream = warehouseStream;
    if (warehouseStream.textfieldId.text == '') {
      newWarehouseStream.textfieldId.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newWarehouseStream.textfieldId.validation =
          ValidationFormModel.trueValid();
    }
    return newWarehouseStream;
  }

  WarehouseStreamModel _validName(WarehouseStreamModel warehouseStream) {
    WarehouseStreamModel newWarehouseStream = warehouseStream;
    if (warehouseStream.textfieldName.text == '') {
      newWarehouseStream.textfieldName.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newWarehouseStream.textfieldName.validation =
          ValidationFormModel.trueValid();
    }
    return newWarehouseStream;
  }

  WarehouseStreamModel _validManager(WarehouseStreamModel warehouseStream) {
    WarehouseStreamModel newWarehouseStream = warehouseStream;
    if (warehouseStream.dropdownManager.value == '') {
      newWarehouseStream.dropdownManager.validation = ValidationFormModel(
          isValid: false, errorMessage: 'Selecione a un encargado de almacén');
    } else {
      newWarehouseStream.dropdownManager.validation =
          ValidationFormModel.trueValid();
    }
    return newWarehouseStream;
  }

  Future<void> initial() async {
    emit(WarehouseStreamModel.initial());
    final WarehouseStreamModel warehouseStream = WarehouseStreamModel(
      dropdownManager: WHDropdownModel.initial(),
      textfieldId: WHTextfieldModel.initial(),
      textfieldName: WHTextfieldModel.initial(),
    );
    emit(warehouseStream);
  }

  Future<void> changeTextfield(
      TextfieldModel textfield, int elementForm) async {
    WarehouseStreamModel warehouseStream = state;
    if (elementForm == 0) {
      warehouseStream.textfieldId.text = textfield.text;
      warehouseStream.textfieldId.position = textfield.position;
      warehouseStream = _validId(warehouseStream);
    }
    if (elementForm == 1) {
      warehouseStream.textfieldName.text = textfield.text;
      warehouseStream.textfieldName.position = textfield.position;
      warehouseStream = _validName(warehouseStream);
    }
    emit(WarehouseStreamModel.initial());
    emit(warehouseStream);
  }

  Future<void> changeDropdown(String value) async {
    WarehouseStreamModel warehouseStream = state;
    warehouseStream.dropdownManager.value = value;
    warehouseStream = _validManager(warehouseStream);
    emit(WarehouseStreamModel.initial());
    emit(warehouseStream);
  }

  Future<void> allValidate() async {
    WarehouseStreamModel warehouseStream = state;
    warehouseStream = _validId(warehouseStream);
    warehouseStream = _validName(warehouseStream);
    warehouseStream = _validManager(warehouseStream);
    emit(WarehouseStreamModel.initial());
    emit(warehouseStream);
  }

  Future<void> editStream(WarehouseStreamModel newWarehouseStream) async {
    emit(WarehouseStreamModel.initial());
    emit(newWarehouseStream);
  }
}*/
