import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/password_visibility/password_visibility_state.dart';

class PasswordVisibilityCubit extends Cubit<PasswordVisibilityState> {
  PasswordVisibilityCubit() : super(PVIsVisibleState());

  void visibility() async {
    try {
      if (state is PVIsNotVisibleState) {
        emit(PVIsVisibleState());
      } else if (state is PVIsVisibleState) {
        emit(PVIsNotVisibleState());
      }
    } catch (e) {
      emit(PVErrorState(error: e.toString()));
      //print(e.toString());
    }
  }

  Future<bool> isVisible() async {
    if (state is PVIsNotVisibleState) {
      return true;
    } else if (state is PVIsVisibleState) {
      return false;
    } else {
      return false;
    }
  }
}
