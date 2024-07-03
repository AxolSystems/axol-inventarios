/// Modelo de datos que contiene las propiedades del usuario.
///
/// TODO: Cambiar metodos por enums.

class UserModel {
  final String name;
  final int id;
  final String rol;
  final String password;
  final int theme;
  final Map<String, Map<String, String>> views;

  static String get rolAdmin => 'admin';
  static String get rolVendor => 'vendor';
  static String get rolSup => 'sup';

  static String get viewTableColumnWidth => 'viewTableColumnWidth';

  const UserModel({
    required this.name,
    required this.id,
    required this.rol,
    required this.password,
    required this.theme,
    required this.views,
  });

  UserModel.empty()
      : name = '',
        id = -1,
        rol = '',
        password = '',
        theme = 0,
        views = {};

    /// Convierte el map de views de base de datos al map utilizado
    /// en el sistema.
  static Map<String, Map<String, String>> decodeViews(
      Map<String, dynamic> mapDb) {
    Map<String, Map<String, String>> map = {};
    Map<String, dynamic> dynamicMap = {};
    Map<String, String> stringMap = {};

    for (String key in mapDb.keys) {
      dynamicMap = mapDb[key];
      for (String subKey in dynamicMap.keys) {
        stringMap[subKey] = dynamicMap[subKey].toString();
      }
      map[key] = stringMap;
    }

    return map;
  }

  /// Convierte el map de views del sistema a una lista de string.
  static List<String> codeViewToList(Map<String,Map<String,String>> map) {
    List<String> list = [];
    String value;
    Map<String,String> subMap = {};

    for (String key in map.keys) {
      subMap = map[key]!;
      value = '$key\$\$';
      for (String subKey in subMap.keys) {
        value = '$value$subKey%%${subMap[subKey]}~';
      }
      list.add(value);
    }

    return list;
  }
}
