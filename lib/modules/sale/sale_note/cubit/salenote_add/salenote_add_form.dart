import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/saelnote_add_form_model.dart';

class SaleNoteAddForm extends Cubit<SaleNoteAddFormModel>{
  SaleNoteAddForm() : super(SaleNoteAddFormModel.empty());

  void setForm(SaleNoteAddFormModel form) {
    emit(SaleNoteAddFormModel.empty());
    emit(form);
  }

  void sumTotal(int index) {
    SaleNoteAddFormModel form  = state;
    double total = 0;
    double subtotal = form.productList[index].subtotal;
    final quantity = double.tryParse(form.productList[index].quantity.value) ?? 0;
    final unitPrice = double.tryParse(form.productList[index].unitPrice.value) ?? 0;
    subtotal = quantity * unitPrice;
    form.productList[index].subtotal = subtotal;
    for (var row in form.productList) {
      total = total + row.subtotal;
    }
    form.total = total;
    emit(SaleNoteAddFormModel.empty());
    emit(form);
  }
}