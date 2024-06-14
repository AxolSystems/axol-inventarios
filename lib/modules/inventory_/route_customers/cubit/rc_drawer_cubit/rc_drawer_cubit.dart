import 'package:axol_inventarios/modules/inventory_/route_customers/model/rc_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/model/routcustomer_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../user/model/user_model.dart';
import '../../../../user/repository/user_repo.dart';
import '../../repository/routecustomer_repo.dart';
import 'rc_drawer_state.dart';

class RcDrawerCubit extends Cubit<RcDrawerState> {
  RcDrawerCubit() : super(InitialState());

  Future<void> initial() async {
    try {
      UserModel user;
      List<String> response = [];
      emit(InitialState());
      emit(LoadingState());
      user = await LocalUser().getLocalUser();
      response.add('user:${user.name}');
      emit(LoadedState(response: response));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> changeCompareId(String id) async {
    try {
      List<String> response = [];
      bool existId;
      emit(InitialState());
      emit(LoadingState());
      existId = await RoutcustomerRepo().existId(id);
      if (existId) {
        response.add('validation:false/Id existente');
      }
      emit(LoadedState(response: response));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> change() async {
    try {
      List<String> response = [];
      emit(InitialState());
      emit(LoadingState());
      emit(LoadedState(response: response));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> insertRc(RcFormModel rcForm) async {
    try {
      List<String> response = [];
      emit(InitialState());
      emit(LoadingState());
      final RoutcustomerModel rc;
      final Map<String, dynamic> address = {
        RoutcustomerModel.pAddress: rcForm.address.value,
        RoutcustomerModel.pHood: rcForm.hood.value,
        RoutcustomerModel.pTown: rcForm.town.value,
        RoutcustomerModel.pCountry: rcForm.country.value,
      };
      final Map<String, dynamic> validation = {
        RoutcustomerModel.pStatus: rcForm.status,
        RoutcustomerModel.pAdminUser: rcForm.user,
      };
      rc = RoutcustomerModel(
          id: int.parse(rcForm.id.value),
          name: rcForm.name.value,
          location: rcForm.location.value,
          address: address,
          validation: validation,
          vendor: '' // cambiar
          );
      await RoutcustomerRepo().insertRc(rc);
      emit(LoadedState(response: response));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
