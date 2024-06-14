import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../user/model/user_model.dart';
import '../../../../user/repository/user_repo.dart';
import 'inventory_view_state.dart';

class InventoryViewCubit extends Cubit<InventoryViewState> {
  InventoryViewCubit() : super(InitialInventoryViewState());

  Future<void> initLoad() async {
    try {
      emit(InitialInventoryViewState());
      emit(LoadingInventoryViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedInventoryViewState(user: user));
    } catch (e) {
      emit(ErrorInventoryViewState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialInventoryViewState());
      emit(LoadingInventoryViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedInventoryViewState(user: user));
    } catch (e) {
      emit(ErrorInventoryViewState(error: e.toString()));
    }
  }
}