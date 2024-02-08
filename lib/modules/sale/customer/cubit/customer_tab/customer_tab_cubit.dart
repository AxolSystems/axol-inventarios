import 'package:axol_inventarios/modules/sale/customer/model/customer_model.dart';
import 'package:axol_inventarios/modules/sale/customer/repository/customer_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/tableview_form_model.dart';
import 'customer_tab_state.dart';

class CustomerTabCubit extends Cubit<CustomerTabState> {
  CustomerTabCubit() : super(InitialCustomerTabState());

  Future<void> load(TableViewFormModel form) async {
    List<CustomerModel> customerListDB;
    try {
      final String find = form.finder.text;
      final int rangeMax;
      final int rangeMin;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      emit(InitialCustomerTabState());
      emit(LoadingCustomerTabState());
      countReg = await CustomerRepo().countRecords();
      rangeMax = (form.currentPage * limit) - 1;
      rangeMin = (form.currentPage * limit) - limit;
      customerListDB = await CustomerRepo()
          .fetchCustomersIlike(find, rangeMax: rangeMax, rangeMin: rangeMin);
      form.totalReg = countReg;
      form.limitPage = (countReg / limit).ceil();
      emit(LoadedCustomerTabState(customerList: customerListDB));
    } catch (e) {
      emit(InitialCustomerTabState());
      emit(ErrorCustomerTabState(error: e.toString()));
    }
  }

  Future<void> initLoad(TableViewFormModel form) async {
    List<CustomerModel> customerListDB;
    try {
      final String find = form.finder.text;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      emit(InitialCustomerTabState());
      emit(LoadingCustomerTabState());
      countReg = await CustomerRepo().countRecords();
      customerListDB = await CustomerRepo()
          .fetchCustomersIlike(find, rangeMax: limit - 1, rangeMin: 0);
      form.currentPage = 1;
      form.totalReg = countReg;
      form.limitPage = (countReg / limit).ceil();
      emit(LoadedCustomerTabState(customerList: customerListDB));
    } catch (e) {
      emit(InitialCustomerTabState());
      emit(ErrorCustomerTabState(error: e.toString()));
    }
  }
}
