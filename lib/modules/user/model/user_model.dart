/// Modelo de datos que contiene las propiedades del usuario.
/// 
/// TODO: Cambiar metodos por enums.
/// TODO: Agregar theme a una propiedad de tipo Map o modelo de datos, 
/// el cual contendrá todas las preferencias del usuario.m

class UserModel {
  final String name;
  final int id;
  final String rol;
  final String password;
  final int theme;

  static String get rolAdmin => 'admin';
  static String get rolVendor => 'vendor';
  static String get rolSup => 'sup';

  const UserModel({
    required this.name,
    required this.id,
    required this.rol,
    required this.password,
    required this.theme,
  });

  UserModel.empty()
      : name = '',
        id = -1,
        rol = '',
        password = '',
        theme = 0;
}
