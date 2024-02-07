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
      emit(InitialCustomerTabState());
      emit(LoadingCustomerTabState());
      countReg = await CustomerRepo().countRecords();
      customerListDB = await CustomerRepo()
          .fetchCustomersIlike(find, rangeMax: rangeMax, rangeMin: rangeMin);
      emit(LoadedCustomerTabState(customerList: customerListDB));
    } catch (e) {
      emit(InitialCustomerTabState());
      emit(ErrorCustomerTabState(error: e.toString()));
    }
  }
}
