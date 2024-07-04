import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user_model.dart';

abstract class UserRepo {
  static const String _table = 'users';
  static const String _user = 'user_name';
  static const String _id = 'id';
  static const String _rol = 'rol';
  static const String _password = 'password';
  static const String _theme = 'theme';
  static const String _views = 'views';
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
        theme: userData.first[UserRepo._theme] ?? 0,
        views: userData.first[UserRepo._views] ?? {},
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
            password: UserRepo._password,
            theme: element[UserRepo._theme] ?? 0,
            views: element[UserRepo._views] ?? {});
        users.add(user);
      }
    }
    return (users);
  }

  Future<void> updateTheme(int id, int theme) async {
    await supabase
        .from(UserRepo._table)
        .update({UserRepo._theme: theme}).eq(UserRepo._id, id);
  }
}

class LocalUser extends UserRepo {
  Future<UserModel> getLocalUser() async {
    final UserModel user;
    final pref = await SharedPreferences.getInstance();
    final String? localUser = pref.getString(UserRepo._user);
    final String? localRol = pref.getString(UserRepo._rol);
    final int localId = pref.getInt(UserRepo._id) ?? -1;
    final int localThem = pref.getInt(UserRepo._theme) ?? 0;
    final List<String> localViews = pref.getStringList(UserRepo._views) ?? [];
    Map<String,Map<String,String>> mapViews = {};
    Map<String,String> mapProp = {};

    if (localUser != null && localRol != null) {
      for (String view in localViews) {
        for (String prop in view.split('\$\$').last.split('~')) {
          mapProp[prop.split('%%').first] = prop.split('%%').last;
        }
        mapViews[view.split('\$\$').first] = mapProp;
      }

      user = UserModel(
        name: localUser,
        id: localId,
        rol: localRol,
        password: '',
        theme: localThem,
        views: mapViews,
      );
    } else {
      user = const UserModel(
        name: '',
        id: -1,
        rol: '',
        password: '',
        theme: 0,
        views: {},
      );
    }
    return user;
  }

  Future<void> setLocalUser(
    String newLocalUser,
    String newLocalRol,
    int id,
    int theme,
    List<String> views,
  ) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(UserRepo._user, newLocalUser);
    await pref.setString(UserRepo._rol, newLocalRol);
    await pref.setInt(UserRepo._id, id);
    await pref.setInt(UserRepo._theme, theme);
    await pref.setStringList(UserRepo._views, views);
  }

  Future<void> setTheme(int theme) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(UserRepo._theme, theme);
  }
}
