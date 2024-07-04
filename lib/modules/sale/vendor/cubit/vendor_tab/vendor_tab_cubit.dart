import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../user/model/user_model.dart';
import '../../../../user/repository/user_repo.dart';
import '../../model/vendor_model.dart';
import '../../repository/vendor_repo.dart';
import 'vendor_tab_state.dart';

class VendorTabCubit extends Cubit<VendorTabState> {
  VendorTabCubit() : super(InitialVendorTabState());

  Future<void> load(String find) async {
    List<VendorModel> vendorListDB;
    try {
      final UserModel user;
      emit(InitialVendorTabState());
      user = await LocalUser().getLocalUser();
      emit(LoadingVendorTabState(user: user));
      vendorListDB = await VendorRepo().fetchVendorIlike(find);
      emit(LoadedVendorTabState(vendorList: vendorListDB, user: user));
    } catch (e) {
      emit(InitialVendorTabState());
      emit(ErrorVendorTabState(error: e.toString()));
    }
  }
}