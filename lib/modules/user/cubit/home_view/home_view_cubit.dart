import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/user_model.dart';
import '../../repository/user_repo.dart';
import 'home_view_state.dart';

class HomeViewCubit extends Cubit<HomeViewState> {
  HomeViewCubit() : super(InitialHomeViewState());

  Future<void> initLoad() async {
    try {
      emit(InitialHomeViewState());
      emit(LoadingHomeViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedHomeViewState(user: user));
    } catch (e) {
      emit(ErrorHomeViewState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialHomeViewState());
      emit(LoadingHomeViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedHomeViewState(user: user));
    } catch (e) {
      emit(ErrorHomeViewState(error: e.toString()));
    }
  }
}