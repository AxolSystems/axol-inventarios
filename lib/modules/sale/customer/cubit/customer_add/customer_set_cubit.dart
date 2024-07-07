<<<<<<< HEAD:lib/modules/sale/customer/cubit/customer_add/customer_add_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_form_model.dart';
import '../../../../../models/validation_form_model.dart';
import '../../model/customer_add_form_model.dart';
import '../../model/customer_model.dart';
import '../../repository/customer_repo.dart';
import 'customer_add_state.dart';

class CustomerAddCubit extends Cubit<CustomerAddState> {
  CustomerAddCubit() : super(InitialCustomerAddState());

  Future<void> loadAvailableId(CustomerAddFormModel form) async {
    CustomerAddFormModel upForm = form;
    int availableId = -1;
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      availableId = await CustomerRepo().fetchAvailableId();
      upForm.id.value = availableId.toString();
      emit(LoadedCustomerAddState(form: upForm, focusIndex: -1));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> load(CustomerAddFormModel form) async {
    try {
      emit(InitialCustomerAddState());
      emit(LoadedCustomerAddState(form: form, focusIndex: -1));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> loadFormValidation(CustomerAddFormModel form) async {
    CustomerAddFormModel upForm = form;
    bool idExist = true;
    int id;
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      id = int.tryParse(form.id.value) ?? -1;
      idExist = await CustomerRepo().existId(id);
      if (idExist == false) {
        upForm.id.validation = ValidationFormModel(
          isValid: false,
          errorMessage: form.emIdInvalid,
        );
      } else {
        upForm.id.validation = ValidationFormModel(
          isValid: true,
          errorMessage: '',
        );
      }
      if (form.name.value == '') {
        upForm.name.validation = ValidationFormModel(
          isValid: false,
          errorMessage: form.emNameInvalid,
        );
      } else {
        upForm.name.validation = ValidationFormModel(
          isValid: true,
          errorMessage: '',
        );
      }
      //upForm = CustomerAddFormModel.allFalseLoading(upForm);
      emit(LoadedCustomerAddState(form: upForm, focusIndex: -1));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> loadSingleValidation(
      CustomerAddFormModel form, String key) async {
    CustomerAddFormModel upForm = form;
    bool idExist = true;
    List<TextfieldFormModel> listForm = CustomerAddFormModel.formToList(form);
    int id;
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      for (int i = 0; i < listForm.length; i++) {
        var element = listForm[i];
        if (element.key == key && key == CustomerModel.empty().tId) {
          id = int.tryParse(form.id.value) ?? -1;
          idExist = await CustomerRepo().existId(id);
          if (idExist) {
            upForm.id.validation = ValidationFormModel(
              isValid: false,
              errorMessage: form.emIdInvalid,
            );
          } else {
            upForm.id.validation = ValidationFormModel(
              isValid: true,
              errorMessage: '',
            );
          }
        } else if (element.key == key && key == CustomerModel.empty().tName) {
          if (form.name.value == '') {
            upForm.name.validation = ValidationFormModel(
              isValid: false,
              errorMessage: form.emNameInvalid,
            );
          } else {
            upForm.name.validation = ValidationFormModel(
              isValid: true,
              errorMessage: '',
            );
          }
        }
      }
      //upForm = CustomerAddFormModel.allFalseLoading(upForm);
      emit(LoadedCustomerAddState(form: upForm, focusIndex: -1));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> loadSingleValidationEnter(
      CustomerAddFormModel form, String key, int nextFocus) async {
    CustomerAddFormModel upForm = form;
    bool idExist = true;
    List<TextfieldFormModel> listForm = CustomerAddFormModel.formToList(form);
    int id;
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      for (int i = 0; i < listForm.length; i++) {
        var element = listForm[i];
        if (element.key == key && key == CustomerModel.empty().tId) {
          id = int.tryParse(form.id.value) ?? -1;
          idExist = await CustomerRepo().existId(id);
          if (idExist) {
            upForm.id.validation = ValidationFormModel(
              isValid: false,
              errorMessage: form.emIdInvalid,
            );
          } else {
            upForm.id.validation = ValidationFormModel(
              isValid: true,
              errorMessage: '',
            );
          }
        } else if (element.key == key && key == CustomerModel.empty().tName) {
          if (form.name.value == '') {
            upForm.name.validation = ValidationFormModel(
              isValid: false,
              errorMessage: form.emNameInvalid,
            );
          } else {
            upForm.name.validation = ValidationFormModel(
              isValid: true,
              errorMessage: '',
            );
          }
        }
      }
      //upForm = CustomerAddFormModel.allFalseLoading(upForm);
      emit(LoadedCustomerAddState(form: upForm, focusIndex: nextFocus));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> save(form) async {
    CustomerAddFormModel upForm = form;
    bool idExist = true;
    bool isValid = true;
    int id;
    final List<TextfieldFormModel> listForm =
        CustomerAddFormModel.formToList(form);
    final CustomerModel customer = CustomerAddFormModel.formToCustomer(form);
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      id = int.tryParse(form.id.value) ?? -1;
      idExist = await CustomerRepo().existId(id);
      if (idExist) {
        upForm.id.validation = ValidationFormModel(
          isValid: false,
          errorMessage: form.emIdInvalid,
        );
      } else {
        upForm.id.validation = ValidationFormModel(
          isValid: true,
          errorMessage: '',
        );
      }
      if (form.name.value == '') {
        upForm.name.validation = ValidationFormModel(
          isValid: false,
          errorMessage: form.emNameInvalid,
        );
      } else {
        upForm.name.validation = ValidationFormModel(
          isValid: true,
          errorMessage: '',
        );
      }
      for (var element in listForm) {
        if (element.validation.isValid == false) {
          isValid = false;
        }
      }
      if (isValid) {
        await CustomerRepo().insertCustomer(customer);
        emit(SavedCustomerAddState());
      } else {
        emit(LoadedCustomerAddState(form: upForm, focusIndex: -1));
      }
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }
}
=======
import 'dart:js_interop';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_form_model.dart';
import '../../../../../models/validation_form_model.dart';
import '../../model/customer_add_form_model.dart';
import '../../model/customer_model.dart';
import '../../repository/customer_repo.dart';
import 'customer_add_state.dart';

class CustomerSetCubit extends Cubit<CustomerAddState> {
  CustomerSetCubit() : super(InitialCustomerAddState());

  Future<void> initLoad(
      CustomerAddFormModel form, CustomerModel? customerEdit) async {
    CustomerAddFormModel upForm = form;
    int availableId = -1;
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());

      if (customerEdit != null) {
        form.country.value = customerEdit.country ?? '';
        form.hood.value = customerEdit.hood ?? '';
        form.id.value = customerEdit.id.toString();
        form.intNumber.value = customerEdit.intNumber ?? '';
        form.name.value = customerEdit.name;
        form.outNumber.value = customerEdit.outNumber ?? '';
        form.phoneNumber.value = customerEdit.phoneNumber ?? '';
        form.postalCode.value = customerEdit.postalCode ?? '';
        form.rfc.value = customerEdit.rfc ?? '';
        form.street.value = customerEdit.street ?? '';
        form.town.value = customerEdit.town ?? '';
      } else {
        availableId = await CustomerRepo().fetchAvailableId();
        upForm.id.value = availableId.toString();
      }
      emit(LoadedCustomerAddState(form: upForm, focusIndex: -1));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> load(CustomerAddFormModel form) async {
    try {
      emit(InitialCustomerAddState());
      emit(LoadedCustomerAddState(form: form, focusIndex: -1));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> loadFormValidation(CustomerAddFormModel form) async {
    CustomerAddFormModel upForm = form;
    bool idExist = true;
    int id;
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      id = int.tryParse(form.id.value) ?? -1;
      idExist = await CustomerRepo().existId(id);
      if (idExist == false) {
        upForm.id.validation = ValidationFormModel(
          isValid: false,
          errorMessage: form.emIdInvalid,
        );
      } else {
        upForm.id.validation = ValidationFormModel(
          isValid: true,
          errorMessage: '',
        );
      }
      if (form.name.value == '') {
        upForm.name.validation = ValidationFormModel(
          isValid: false,
          errorMessage: form.emNameInvalid,
        );
      } else {
        upForm.name.validation = ValidationFormModel(
          isValid: true,
          errorMessage: '',
        );
      }
      //upForm = CustomerAddFormModel.allFalseLoading(upForm);
      emit(LoadedCustomerAddState(form: upForm, focusIndex: -1));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> loadSingleValidation(
      CustomerAddFormModel form, String key) async {
    CustomerAddFormModel upForm = form;
    bool idExist = true;
    List<TextfieldFormModel> listForm = CustomerAddFormModel.formToList(form);
    int id;
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      for (int i = 0; i < listForm.length; i++) {
        var element = listForm[i];
        if (element.key == key && key == CustomerModel.empty().tId) {
          id = int.tryParse(form.id.value) ?? -1;
          idExist = await CustomerRepo().existId(id);
          if (idExist) {
            upForm.id.validation = ValidationFormModel(
              isValid: false,
              errorMessage: form.emIdInvalid,
            );
          } else {
            upForm.id.validation = ValidationFormModel(
              isValid: true,
              errorMessage: '',
            );
          }
        } else if (element.key == key && key == CustomerModel.empty().tName) {
          if (form.name.value == '') {
            upForm.name.validation = ValidationFormModel(
              isValid: false,
              errorMessage: form.emNameInvalid,
            );
          } else {
            upForm.name.validation = ValidationFormModel(
              isValid: true,
              errorMessage: '',
            );
          }
        }
      }
      //upForm = CustomerAddFormModel.allFalseLoading(upForm);
      emit(LoadedCustomerAddState(form: upForm, focusIndex: -1));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> loadSingleValidationEnter(
      CustomerAddFormModel form, String key, int nextFocus) async {
    CustomerAddFormModel upForm = form;
    bool idExist = true;
    List<TextfieldFormModel> listForm = CustomerAddFormModel.formToList(form);
    int id;
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      for (int i = 0; i < listForm.length; i++) {
        var element = listForm[i];
        if (element.key == key && key == CustomerModel.empty().tId) {
          id = int.tryParse(form.id.value) ?? -1;
          idExist = await CustomerRepo().existId(id);
          if (idExist) {
            upForm.id.validation = ValidationFormModel(
              isValid: false,
              errorMessage: form.emIdInvalid,
            );
          } else {
            upForm.id.validation = ValidationFormModel(
              isValid: true,
              errorMessage: '',
            );
          }
        } else if (element.key == key && key == CustomerModel.empty().tName) {
          if (form.name.value == '') {
            upForm.name.validation = ValidationFormModel(
              isValid: false,
              errorMessage: form.emNameInvalid,
            );
          } else {
            upForm.name.validation = ValidationFormModel(
              isValid: true,
              errorMessage: '',
            );
          }
        }
      }
      //upForm = CustomerAddFormModel.allFalseLoading(upForm);
      emit(LoadedCustomerAddState(form: upForm, focusIndex: nextFocus));
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }

  Future<void> save(
      CustomerAddFormModel form, CustomerModel? customerEdit) async {
    CustomerAddFormModel upForm = form;
    bool idExist = true;
    bool isValid = true;
    int id;
    final List<TextfieldFormModel> listForm =
        CustomerAddFormModel.formToList(form);
    final CustomerModel customer = CustomerAddFormModel.formToCustomer(form);
    try {
      emit(InitialCustomerAddState());
      emit(LoadingCustomerAddState());
      id = int.tryParse(form.id.value) ?? -1;
      idExist = await CustomerRepo().existId(id);
      if (idExist && customerEdit == null) {
        upForm.id.validation = ValidationFormModel(
          isValid: false,
          errorMessage: form.emIdInvalid,
        );
      } else {
        upForm.id.validation = ValidationFormModel(
          isValid: true,
          errorMessage: '',
        );
      }
      if (form.name.value == '') {
        upForm.name.validation = ValidationFormModel(
          isValid: false,
          errorMessage: form.emNameInvalid,
        );
      } else {
        upForm.name.validation = ValidationFormModel(
          isValid: true,
          errorMessage: '',
        );
      }
      for (var element in listForm) {
        if (element.validation.isValid == false) {
          isValid = false;
        }
      }
      if (isValid) {
        if (customerEdit != null) {
          await CustomerRepo().update(customer);
        } else {
          await CustomerRepo().insertCustomer(customer);
        }
        emit(SavedCustomerAddState());
      } else {
        emit(LoadedCustomerAddState(form: upForm, focusIndex: -1));
      }
    } catch (e) {
      emit(InitialCustomerAddState());
      emit(ErrorCustomerAddState(error: e.toString()));
    }
  }
}
>>>>>>> main:lib/modules/sale/customer/cubit/customer_add/customer_set_cubit.dart
