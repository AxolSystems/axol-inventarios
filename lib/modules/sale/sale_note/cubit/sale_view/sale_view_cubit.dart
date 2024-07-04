import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../user/model/user_model.dart';
import '../../../../user/repository/user_repo.dart';
import 'sale_view_state.dart';

class SaleViewCubit extends Cubit<SaleViewState> {
  SaleViewCubit() : super(InitialSaleViewState());

  Future<void> initLoad() async {
    try {
      emit(InitialSaleViewState());
      emit(LoadingSaleViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedSaleViewState(user: user));
    } catch (e) {
      emit(ErrorSaleViewState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSaleViewState());
      emit(LoadingSaleViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedSaleViewState(user: user));
    } catch (e) {
      emit(ErrorSaleViewState(error: e.toString()));
    }
  }
}