import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/vendor_model.dart';
import '../../repository/vendor_repo.dart';
import 'vendor_delete_state.dart';

class VendorDeleteCubit extends Cubit<VendorDeleteState> {
  VendorDeleteCubit() : super(InitialVendorDeleteState());

  Future<void> load() async {
    try {
      emit(InitialVendorDeleteState());
      emit(LoadedVendorDeleteState());
    } catch (e) {
      emit(InitialVendorDeleteState());
      emit(ErrorVendorDeleteState(error: e.toString()));
    }
  }
  
  Future<void> deleteCustomer(VendorModel vendor) async {
    try {
      emit(InitialVendorDeleteState());
      emit(LoadingVendorDeleteState());
      await VendorRepo().delete(vendor);
      emit(CloseVendorDeleteState());
    } catch (e) {
      emit(InitialVendorDeleteState());
      emit(ErrorVendorDeleteState(error: e.toString()));
    }
  }
}