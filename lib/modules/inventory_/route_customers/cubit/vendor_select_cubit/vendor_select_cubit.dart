import 'package:axol_inventarios/modules/sale/vendor/repository/vendor_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../sale/vendor/model/vendor_model.dart';
import 'vendor_select_state.dart';

class VendorSelectCubit extends Cubit<VendorSelectState> {
  VendorSelectCubit() : super(InitialState());

  Future<void> load(TextfieldModel finder) async {
    try {
      List<VendorModel> vendorsDB;
      emit(InitialState());
      emit(LoadingState(textfieldFinder: finder));
      vendorsDB = await VendorRepo().fetchVendorIlike(finder.text);
      emit(LoadedState(textfieldFinder: finder, vendorList: vendorsDB));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
