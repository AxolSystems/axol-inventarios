import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/validation_form_model.dart';
import '../model/rc_form_model.dart';

class RcFormCubit extends Cubit<RcFormModel> {
  RcFormCubit() : super(RcFormModel.empty());

  Future<void> changeForm(String text, int position, int elementForm) async {
    RcFormModel rcForm = state;
    if (elementForm == 0) {
      rcForm.id.value = text;
      rcForm.id.position = position;
      rcForm = _validId(rcForm);
    }
    if (elementForm == 1) {
      rcForm.name.value = text;
      rcForm.name.position = position;
      rcForm = _validName(rcForm);
    }
    if (elementForm == 2) {
      rcForm.location.value = text;
      rcForm.location.position = position;
      rcForm = _validLocation(rcForm);
    }
    if (elementForm == 3) {
      rcForm.address.value = text;
      rcForm.address.position = position;
      rcForm = _validAddress(rcForm);
    }
    if (elementForm == 4) {
      rcForm.hood.value = text;
      rcForm.hood.position = position;
      rcForm = _validHood(rcForm);
    }
    if (elementForm == 5) {
      rcForm.town.value = text;
      rcForm.town.position = position;
      rcForm = _validTown(rcForm);
    }
    if (elementForm == 6) {
      rcForm.country.value = text;
      rcForm.country.position = position;
      rcForm = _validCountry(rcForm);
    }
    if (elementForm == 7) {
      rcForm.vendor.value = text;
      rcForm.vendor.position = position;
      rcForm = _validVendor(rcForm);
    }
  }

  Future<void> changeStatus(bool status) async {
    RcFormModel rcForm = state;
    rcForm.status = status;
  }

  Future<void> changeUser(String user) async {
    RcFormModel rcForm = state;
    rcForm.user = user;
  }

  Future<void> allValidate() async {
    RcFormModel rcForm = state;
    rcForm = _validId(rcForm);
    rcForm = _validName(rcForm);
    rcForm = _validLocation(rcForm);
    rcForm = _validAddress(rcForm);
    rcForm = _validHood(rcForm);
    rcForm = _validTown(rcForm);
    rcForm = _validCountry(rcForm);
    rcForm = _validVendor(rcForm);
    emit(RcFormModel.empty());
    emit(rcForm);
  }

  void setForm(RcFormModel rcForm) {
    emit(RcFormModel.empty());
    emit(rcForm);
  }

  // --------- Metodos privados ---------

  RcFormModel _validId(RcFormModel rcForm) {
    RcFormModel newRcForm = rcForm;
    if (newRcForm.id.value == '') {
      newRcForm.id.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newRcForm.id.validation = ValidationFormModel.trueValid();
    }
    return newRcForm;
  }

  RcFormModel _validName(RcFormModel rcForm) {
    RcFormModel newRcForm = rcForm;
    if (newRcForm.name.value == '') {
      newRcForm.name.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newRcForm.name.validation = ValidationFormModel.trueValid();
    }
    return newRcForm;
  }

  RcFormModel _validLocation(RcFormModel rcForm) {
    RcFormModel newRcForm = rcForm;
    if (newRcForm.location.value == '') {
      newRcForm.location.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newRcForm.location.validation = ValidationFormModel.trueValid();
    }
    return newRcForm;
  }

  RcFormModel _validAddress(RcFormModel rcForm) {
    RcFormModel newRcForm = rcForm;
    if (newRcForm.address.value == '') {
      newRcForm.address.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newRcForm.address.validation = ValidationFormModel.trueValid();
    }
    return newRcForm;
  }

  RcFormModel _validHood(RcFormModel rcForm) {
    RcFormModel newRcForm = rcForm;
    if (newRcForm.hood.value == '') {
      newRcForm.hood.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newRcForm.hood.validation = ValidationFormModel.trueValid();
    }
    return newRcForm;
  }

  RcFormModel _validTown(RcFormModel rcForm) {
    RcFormModel newRcForm = rcForm;
    if (newRcForm.town.value == '') {
      newRcForm.town.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newRcForm.town.validation = ValidationFormModel.trueValid();
    }
    return newRcForm;
  }

  RcFormModel _validCountry(RcFormModel rcForm) {
    RcFormModel newRcForm = rcForm;
    if (newRcForm.country.value == '') {
      newRcForm.country.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newRcForm.country.validation = ValidationFormModel.trueValid();
    }
    return newRcForm;
  }

  RcFormModel _validVendor(RcFormModel rcForm) {
    RcFormModel newRcForm = rcForm;
    if (newRcForm.vendor.value == '') {
      newRcForm.vendor.validation =
          ValidationFormModel(isValid: false, errorMessage: 'Dato no valido');
    } else {
      newRcForm.vendor.validation = ValidationFormModel.trueValid();
    }
    return newRcForm;
  }
}
