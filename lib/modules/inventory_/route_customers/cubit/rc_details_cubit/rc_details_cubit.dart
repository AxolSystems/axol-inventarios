import 'dart:async';

import 'package:axol_inventarios/modules/inventory_/route_customers/model/routcustomer_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../user/model/user_model.dart';
import '../../../../user/repository/user_repo.dart';
import '../../repository/routecustomer_repo.dart';
import 'rc_details_state.dart';

class RcDetailsCubit extends Cubit<RcDetailsState> {
  RcDetailsCubit() : super(InitialState());

  Future<void> initial(RoutcustomerModel rc) async {
    try {
      emit(InitialState());
      emit(LoadingState(isValid: rc.validation[RoutcustomerModel.pStatus]));
      emit(LoadedState(isValid: rc.validation[RoutcustomerModel.pStatus]));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> change(bool isValid) async {
    try {
      emit(InitialState());
      emit(LoadingState(isValid: isValid));
      emit(LoadedState(isValid: isValid));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  Future<void> updateRcValidation(
      RoutcustomerModel rc, bool valid, String user) async {
    try {
      emit(InitialState());
      emit(LoadingState(isValid: valid));
      RoutcustomerModel rcUpdated;
      rcUpdated = RoutcustomerModel(
          id: rc.id,
          name: rc.name,
          location: rc.location,
          address: rc.address,
          vendor: rc.vendor,
          validation: {
            RoutcustomerModel.pAdminUser: user,
            RoutcustomerModel.pStatus: valid
          });
      await RoutcustomerRepo().updateRcValidation(rcUpdated);
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
