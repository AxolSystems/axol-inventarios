import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/user_model.dart';
import '../../repository/user_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoadingState());

  void getUserState() async {
    try {
      emit(AuthLoadingState());
      //final pref = await SharedPreferences.getInstance();
      //print(pref.getStringList('shoppingcart'));
      LocalUser localUser = LocalUser();
      DatabaseUser databaseUser = DatabaseUser();
      UserModel authLocalUser = await localUser.getLocalUser();
      UserModel? authDatabaseUser =
          await databaseUser.readDbUser(authLocalUser.name);

      if (authDatabaseUser != null) {
        emit(AuthAuthenticatedState(user: authDatabaseUser));
      } else {
        emit(AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(error: e.toString()));
    }
  }
}
