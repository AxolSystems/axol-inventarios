import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/customer_model.dart';
import '../../repository/customer_repo.dart';
import 'customer_delete_state.dart';

class CustomerDeleteCubit extends Cubit<CustomerDeleteState> {
  CustomerDeleteCubit() : super(InitialCustomerDeleteState());

  Future<void> load() async {
    try {
      emit(InitialCustomerDeleteState());
      emit(LoadedCustomerDeleteState());
    } catch (e) {
      emit(InitialCustomerDeleteState());
      emit(ErrorCustomerDeleteState(error: e.toString()));
    }
  }
  
  Future<void> deleteCustomer(CustomerModel customer) async {
    try {
      emit(InitialCustomerDeleteState());
      emit(LoadingCustomerDeleteState());
      await CustomerRepo().delete(customer);
      emit(CloseCustomerDeleteState());
    } catch (e) {
      emit(InitialCustomerDeleteState());
      emit(ErrorCustomerDeleteState(error: e.toString()));
    }
  }
}