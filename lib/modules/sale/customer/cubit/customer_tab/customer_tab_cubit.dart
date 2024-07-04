import 'package:axol_inventarios/models/data_response_model.dart';
import 'package:axol_inventarios/modules/sale/customer/model/customer_model.dart';
import 'package:axol_inventarios/modules/sale/customer/repository/customer_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../../../user/model/user_model.dart';
import '../../../../user/repository/user_repo.dart';
import 'customer_tab_state.dart';

class CustomerTabCubit extends Cubit<CustomerTabState> {
  CustomerTabCubit() : super(InitialCustomerTabState());

  Future<void> load(TableViewFormModel form, bool resetPage) async {
    List<CustomerModel> customerListDB = [];
    try {
      final String find = form.finder.text;
      final int rangeMax;
      final int rangeMin;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      DataResponseModel dataResponse;
      emit(InitialCustomerTabState());
      emit(LoadingCustomerTabState());
      if (resetPage) {
        form.currentPage = 1;
      }
      rangeMax = (form.currentPage * limit) - 1;
      rangeMin = (form.currentPage * limit) - limit;
      dataResponse = await CustomerRepo()
          .fetchCustomersIlike(find, rangeMax: rangeMax, rangeMin: rangeMin);
      countReg = dataResponse.count;
      if (dataResponse.dataList is List<CustomerModel>) {
        customerListDB = dataResponse.dataList as List<CustomerModel>;
      }
      form.totalReg = countReg;
      form.limitPage = (countReg / limit).ceil();
      emit(LoadedCustomerTabState(customerList: customerListDB));
    } catch (e) {
      emit(InitialCustomerTabState());
      emit(ErrorCustomerTabState(error: e.toString()));
    }
  }

  Future<void> initLoad(TableViewFormModel form) async {
    List<CustomerModel> customerListDB = [];
    try {
      final UserModel user;
      final String find = form.finder.text;
      final int countReg;
      final int limit = TableViewFormModel.rows50;
      DataResponseModel dataResponse;

      emit(InitialCustomerTabState());

      user = await LocalUser().getLocalUser();
      form.user = user;

      emit(LoadingCustomerTabState());

      dataResponse = await CustomerRepo()
          .fetchCustomersIlike(find, rangeMax: limit - 1, rangeMin: 0);
      countReg = dataResponse.count;
      if (dataResponse.dataList is List<CustomerModel>) {
        customerListDB = dataResponse.dataList as List<CustomerModel>;
      }
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
