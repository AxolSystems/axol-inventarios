import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/validation_form_model.dart';
import '../model/saelnote_add_form_model.dart';

class SalenoteFormCubit extends Cubit<SaleNoteAddFormModel> {
  SalenoteFormCubit() : super(SaleNoteAddFormModel.empty());

  SaleNoteAddFormModel _validCustomer(SaleNoteAddFormModel salenoteForm) {
    SaleNoteAddFormModel newSalenoteForm = salenoteForm;
    if (salenoteForm.customerTf.value == '') {
      newSalenoteForm.customerTf.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newSalenoteForm.customerTf.validation = ValidationFormModel.trueValid();
    }
    return newSalenoteForm;
  }

  SaleNoteAddFormModel _validVendor(SaleNoteAddFormModel salenoteForm) {
    SaleNoteAddFormModel newSalenoteForm = salenoteForm;
    if (salenoteForm.vendorTf.value == '') {
      newSalenoteForm.vendorTf.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newSalenoteForm.vendorTf.validation = ValidationFormModel.trueValid();
    }
    return newSalenoteForm;
  }

  SaleNoteAddFormModel _validWarehouse(SaleNoteAddFormModel salenoteForm) {
    SaleNoteAddFormModel newSalenoteForm = salenoteForm;
    if (salenoteForm.warehouseTf.value == '') {
      newSalenoteForm.warehouseTf.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newSalenoteForm.warehouseTf.validation = ValidationFormModel.trueValid();
    }
    return newSalenoteForm;
  }

  Future<void> change(String text, int position, int elementForm) async {
    SaleNoteAddFormModel salenoteForm = state;
    if (elementForm == 0) {
      salenoteForm.customerTf.value = text;
      salenoteForm.customerTf.position = position;
      salenoteForm = _validCustomer(salenoteForm);
    }
    if (elementForm == 1) {
      salenoteForm.vendorTf.value = text;
      salenoteForm.vendorTf.position = position;
      salenoteForm = _validVendor(salenoteForm);
    }
    if (elementForm == 2) {
      salenoteForm.warehouseTf.value = text;
      salenoteForm.warehouseTf.position = position;
      salenoteForm = _validWarehouse(salenoteForm);
    }
    emit(SaleNoteAddFormModel.empty());
    emit(salenoteForm);
  }

  Future<void> allValidate() async {
    SaleNoteAddFormModel salenoteForm = state;
    salenoteForm = _validCustomer(salenoteForm);
    salenoteForm = _validVendor(salenoteForm);
    salenoteForm = _validWarehouse(salenoteForm);
    emit(SaleNoteAddFormModel.empty());
    emit(salenoteForm);
  }

  void setForm(SaleNoteAddFormModel salenoteForm) {
    emit(SaleNoteAddFormModel.empty());
    emit(salenoteForm);
  }
}
