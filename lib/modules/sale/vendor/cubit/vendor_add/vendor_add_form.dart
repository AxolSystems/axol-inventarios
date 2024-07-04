import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_form_model.dart';
import '../../model/vendor_add_form_model.dart';

class VendorAddForm extends Cubit<VendorAddFormModel>{
  VendorAddForm() : super(VendorAddFormModel.empty());

  void setForm(VendorAddFormModel form) {
    emit(VendorAddFormModel.empty());
    emit(form);
  }
  
  void setName(TextfieldFormModel name) {
    VendorAddFormModel form = state;
    form.name = name;
    emit(VendorAddFormModel.empty());
    emit(form);
  }

  void setId(TextfieldFormModel id) {
    VendorAddFormModel form = state;
    form.id = id;
    emit(VendorAddFormModel.empty());
    emit(form);
  }
}