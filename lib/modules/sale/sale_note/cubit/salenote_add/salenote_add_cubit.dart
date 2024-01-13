import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../customer/model/customer_model.dart';
import '../../../customer/repository/customer_repo.dart';
import '../../model/saelnote_add_form_model.dart';
import 'salenote_add_state.dart';

class SaleNoteAddCubit extends Cubit<SaleNoteAddState> {
  SaleNoteAddCubit() : super(InitialSaleNoteAddState());

  Future<void> load() async {
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      emit(const LoadedSaleNoteAddState(rowFormList: []));
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }

  Future<void> fetchCustomer(String find, SaleNoteAddFormModel form) async {
    SaleNoteAddFormModel upForm = form;
    List<CustomerModel> customerList;
    List<String> findSplit;
    String upFind = find;
    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      find = find.replaceAll(' ', '');
      findSplit = find.split('-');
      if (findSplit.isNotEmpty) {
        upFind = 
      }
      customerList = await CustomerRepo().fetchCustomersIlike(find);
      if (customerList.length == 1) {
        upForm.customer = customerList.first;
        upForm.customerTf.validation = ValidationFormModel.trueValid();
        upForm.customerTf.value = '${customerList.first.id} - ${customerList.first.name}';
      } else {
        upForm.customer = CustomerModel.empty();
        upForm.customerTf.validation = ValidationFormModel(isValid: false, errorMessage: form.emInvalidData);
      }
      emit(const LoadedSaleNoteAddState(rowFormList: []));
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }
}