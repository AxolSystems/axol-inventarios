import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_form_model.dart';
import '../../model/customer_add_form_model.dart';

class CustomerAddForm extends Cubit<CustomerAddFormModel>{
  CustomerAddForm() : super(CustomerAddFormModel.empty());

  void setForm(CustomerAddFormModel form) {
    emit(CustomerAddFormModel.empty());
    emit(form);
  }
  
  void setName(TextfieldFormModel name) {
    CustomerAddFormModel form = state;
    form.name = name;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setId(TextfieldFormModel id) {
    CustomerAddFormModel form = state;
    form.id = id;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setCountry(TextfieldFormModel country) {
    CustomerAddFormModel form = state;
    form.country = country;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setHood(TextfieldFormModel hood) {
    CustomerAddFormModel form = state;
    form.hood = hood;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setIntNumber(TextfieldFormModel intNumber) {
    CustomerAddFormModel form = state;
    form.intNumber = intNumber;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setOutNumber(TextfieldFormModel outNumber) {
    CustomerAddFormModel form = state;
    form.outNumber = outNumber;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setPhoneNumber(TextfieldFormModel phoneNumber) {
    CustomerAddFormModel form = state;
    form.phoneNumber = phoneNumber;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setPostalCode(TextfieldFormModel postalCode){
    CustomerAddFormModel form = state;
    form.postalCode = postalCode;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setRfc(TextfieldFormModel rfc) {
    CustomerAddFormModel form = state;
    form.rfc = rfc;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setStreet(TextfieldFormModel street) {
    CustomerAddFormModel form = state;
    form.street = street;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }

  void setTown(TextfieldFormModel town) {
    CustomerAddFormModel form = state;
    form.town = town;
    emit(CustomerAddFormModel.empty());
    emit(form);
  }
}