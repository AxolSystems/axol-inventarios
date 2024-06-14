import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../user/model/user_model.dart';
import '../../../user/repository/user_repo.dart';
import 'waybill_view_state.dart';

class WaybillViewCubit extends Cubit<WaybillViewState> {
  WaybillViewCubit() : super(InitialWaybillViewState());

  Future<void> initLoad() async {
    try {
      emit(InitialWaybillViewState());
      emit(LoadingWaybillViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedWaybillViewState(user: user));
    } catch (e) {
      emit(ErrorWaybillViewState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialWaybillViewState());
      emit(LoadingWaybillViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedWaybillViewState(user: user));
    } catch (e) {
      emit(ErrorWaybillViewState(error: e.toString()));
    }
  }
}