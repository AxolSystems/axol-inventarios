import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_form_model.dart';
import '../../../../../models/validation_form_model.dart';
import '../../model/vendor_add_form_model.dart';
import '../../model/vendor_model.dart';
import '../../repository/vendor_repo.dart';
import 'vendor_add_state.dart';

class VendorAddCubit extends Cubit<VendorAddState> {
  VendorAddCubit() : super(InitialVendorAddState());

  Future<void> loadAvailableId(VendorAddFormModel form) async {
    VendorAddFormModel upForm = form;
    int availableId = -1;
    try {
      emit(InitialVendorAddState());
      emit(LoadingVendorAddState());
      availableId = await VendorRepo().fetchAvailableId();
      upForm.id.value = availableId.toString();
      emit(LoadedVendorAddState(form: upForm, focusIndex: -1));
    } catch (e) {
      emit(InitialVendorAddState());
      emit(ErrorVendorAddState(error: e.toString()));
    }
  }

  Future<void> load(VendorAddFormModel form) async {
    try {
      emit(InitialVendorAddState());
      emit(LoadedVendorAddState(form: form, focusIndex: -1));
    } catch (e) {
      emit(InitialVendorAddState());
      emit(ErrorVendorAddState(error: e.toString()));
    }
  }

  Future<void> loadFormValidation(VendorAddFormModel form) async {
    VendorAddFormModel upForm = form;
    bool idExist = true;
    int id;
    try {
      emit(InitialVendorAddState());
      emit(LoadingVendorAddState());
      id = int.tryParse(form.id.value) ?? -1;
      idExist = await VendorRepo().existId(id);
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
      emit(LoadedVendorAddState(form: upForm, focusIndex: -1));
    } catch (e) {
      emit(InitialVendorAddState());
      emit(ErrorVendorAddState(error: e.toString()));
    }
  }

  Future<void> loadSingleValidation(
      VendorAddFormModel form, {String? key, int? nextFocus}) async {
    final String key_ = key ?? '';
    final int nextFocus_ = nextFocus ?? -1;
    VendorAddFormModel upForm = form;
    bool idExist = true;
    List<TextfieldFormModel> listForm = VendorAddFormModel.formToList(form);
    int id;
    try {
      emit(InitialVendorAddState());
      emit(LoadingVendorAddState());
      for (int i = 0; i < listForm.length; i++) {
        var element = listForm[i];
        if (element.key == key_ && key_ == VendorModel.empty().tId) {
          id = int.tryParse(form.id.value) ?? -1;
          idExist = await VendorRepo().existId(id);
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
        } else if (element.key == key_ && key_ == VendorModel.empty().tName) {
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
      emit(LoadedVendorAddState(form: upForm, focusIndex: nextFocus_));
    } catch (e) {
      emit(InitialVendorAddState());
      emit(ErrorVendorAddState(error: e.toString()));
    }
  }

  Future<void> save(form) async {
    VendorAddFormModel upForm = form;
    bool idExist = true;
    bool isValid = true;
    int id;
    final List<TextfieldFormModel> listForm =
        VendorAddFormModel.formToList(form);
    final VendorModel vendor = VendorAddFormModel.formToVendor(form);
    try {
      emit(InitialVendorAddState());
      emit(LoadingVendorAddState());
      id = int.tryParse(form.id.value) ?? -1;
      idExist = await VendorRepo().existId(id);
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
        await VendorRepo().insert(vendor);
        emit(SavedVendorAddState());
      } else {
        emit(LoadedVendorAddState(form: upForm, focusIndex: -1));
      }
    } catch (e) {
      emit(InitialVendorAddState());
      emit(ErrorVendorAddState(error: e.toString()));
    }
  }
}