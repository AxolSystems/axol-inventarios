import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_find.dart';
import '../../../../../utilities/widgets/drawer_find.dart';
import '../../model/vendor_model.dart';
import '../../repository/vendor_repo.dart';

class VendorFindCubit extends Cubit<DrawerFindState> {
  VendorFindCubit() : super(InitialDrawerFindState());

  Future<void> load(String find) async {
    List<VendorModel> vendorsDB;
    List<DataFind> dataList = [];
    DataFind data;
    try {
      emit(InitialDrawerFindState());
      emit(LoadingDrawerFindState());
      vendorsDB = await VendorRepo().fetchVendorIlike(find);
      for (var vendor in vendorsDB) {
        data = DataFind(id: vendor.id.toString(), description: vendor.name, data: vendor);
        dataList.add(data);
      }
      emit(LoadedDrawerFindState(dataList: dataList));
    } catch (e) {
      emit(InitialDrawerFindState());
      emit(ErrorDrawerFindState(error: e.toString()));
    }
  }
}