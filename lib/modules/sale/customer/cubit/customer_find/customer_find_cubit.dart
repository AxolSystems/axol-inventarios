import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_find.dart';
import '../../../../../utilities/widgets/drawer_find.dart';
import '../../model/customer_model.dart';
import '../../repository/customer_repo.dart';

class CustomerFindCubit extends Cubit<DrawerFindState> {
  CustomerFindCubit() : super(InitialDrawerFindState());

  Future<void> load(String find) async {
    List<CustomerModel> customersDB;
    List<DataFind> dataList = [];
    DataFind data;
    try {
      emit(InitialDrawerFindState());
      emit(LoadingDrawerFindState());
      customersDB = await CustomerRepo().fetchCustomersIlike(find);
      for (var customer in customersDB) {
        data = DataFind(id: customer.id.toString(), description: customer.name, data: customer);
        dataList.add(data);
      }
      emit(LoadedDrawerFindState(dataList: dataList, valuesList: const []));
    } catch (e) {
      emit(InitialDrawerFindState());
      emit(ErrorDrawerFindState(error: e.toString()));
    }
  }
}