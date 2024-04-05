class UserModel {
  final String name;
  final int id;
  final String rol;
  final String password;

  static String get rolAdmin => 'admin';
  static String get rolVendor => 'vendor';
  static String get rolSup => 'sup';

  const UserModel(
      {required this.name,
      required this.id,
      required this.rol,
      required this.password});
}
