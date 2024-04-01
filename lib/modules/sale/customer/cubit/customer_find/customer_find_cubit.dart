import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_find.dart';
import '../../../../../utilities/widgets/drawer_find.dart';
import '../../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../model/customer_find_form_model.dart';
import '../../model/customer_model.dart';
import '../../repository/customer_repo.dart';

class CustomerFindCubit extends Cubit<DrawerFindState> {
  CustomerFindCubit() : super(InitialDrawerFindState());

  Future<void> initLoad(CustomerFindFormModel form) async {
    final String find = form.finder.text;
    final int countReg;
    final int limit = TableViewFormModel.rows50;
    List<CustomerModel> customersDB;
    List<DataFind> dataList = [];
    DataFind data;
    try {
      emit(InitialDrawerFindState());
      emit(LoadingDrawerFindState());
      countReg = await CustomerRepo().countRecords();
      customersDB = await CustomerRepo()
          .fetchCustomersIlike(find, rangeMax: limit - 1, rangeMin: 0);
      form.currentPage = 1;
      form.totalReg = countReg;
      form.totalPages = (countReg / limit).ceil();
      for (var customer in customersDB) {
        data = DataFind(
            id: customer.id.toString(),
            description: customer.name,
            data: customer);
        dataList.add(data);
      }
      emit(LoadedDrawerFindState(dataList: dataList, valuesList: const []));
    } catch (e) {
      emit(InitialDrawerFindState());
      emit(ErrorDrawerFindState(error: e.toString()));
    }
  }

  Future<void> load(CustomerFindFormModel form) async {
    final String find = form.finder.text;
    final int rangeMax;
    final int rangeMin;
    final int countReg;
    final int limit = TableViewFormModel.rows50;
    List<CustomerModel> customersDB;
    List<DataFind> dataList = [];
    DataFind data;
    try {
      emit(InitialDrawerFindState());
      emit(LoadingDrawerFindState());
      countReg = await CustomerRepo().countRecords();
      rangeMax = (form.currentPage * limit) - 1;
      rangeMin = (form.currentPage * limit) - limit;
      customersDB = await CustomerRepo()
          .fetchCustomersIlike(find, rangeMax: rangeMax, rangeMin: rangeMin);
      form.totalReg = countReg;
      form.totalPages = (countReg / limit).ceil();
      //customersDB = await CustomerRepo().fetchCustomersIlike(find);
      for (var customer in customersDB) {
        data = DataFind(
            id: customer.id.toString(),
            description: customer.name,
            data: customer);
        dataList.add(data);
      }
      emit(LoadedDrawerFindState(dataList: dataList, valuesList: const []));
    } catch (e) {
      emit(InitialDrawerFindState());
      emit(ErrorDrawerFindState(error: e.toString()));
    }
  }
}

class CustomerFindForm extends Cubit<CustomerFindFormModel> {
  CustomerFindForm() : super(CustomerFindFormModel.empty());
}
