import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user_mdoel.dart';

abstract class UserRepo {
  static const String _table = 'users';
  static const String _user = 'user_name';
  static const String _id = 'id';
  static const String _rol = 'rol';
  static const String _password = 'password';
}

class DatabaseUser extends UserRepo {
  final supabase = Supabase.instance.client;

  Future<UserModel?> readDbUser(String userSearch) async {
    final UserModel? user;
    final userData = await supabase
        .from(UserRepo._table)
        .select<List<Map<String, dynamic>>>('*')
        .eq(UserRepo._user, userSearch);
    if (userData.isNotEmpty) {
      user = UserModel(
        name: userData.first[UserRepo._user],
        id: userData.first[UserRepo._id],
        rol: userData.first[UserRepo._rol],
        password: userData.first[UserRepo._password],
      );
    } else {
      user = null;
    }
    return user;
  }

  Future<List<UserModel>> fetchAllUsers() async {
    List<UserModel> users = [];
    List<Map<String, dynamic>> usersDB = [];
    UserModel user;
    usersDB = await supabase
        .from(UserRepo._table)
        .select<List<Map<String, dynamic>>>();
    if (usersDB.isNotEmpty) {
      for (var element in usersDB) {
        user = UserModel(
            name: element[UserRepo._user],
            id: element[UserRepo._id],
            rol: UserRepo._rol,
            password: UserRepo._password);
        users.add(user);
      }
    }
    return (users);
  }
}

class LocalUser extends UserRepo {
  Future<UserModel> getLocalUser() async {
    final UserModel user;
    final pref = await SharedPreferences.getInstance();
    final String? localUser = pref.getString(UserRepo._user);
    final String? localRol = pref.getString(UserRepo._rol);
    if (localUser != null && localRol != null) {
      user = UserModel(name: localUser, id: -1, rol: localRol, password: '');
    } else {
      user = const UserModel(name: '', id: -1, rol: '', password: '');
    }
    return user;
  }

  Future<void> setLocalUser(String newLocalUser, String newLocalRol) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(UserRepo._user, newLocalUser);
    await pref.setString(UserRepo._rol, newLocalRol);
  }
}
