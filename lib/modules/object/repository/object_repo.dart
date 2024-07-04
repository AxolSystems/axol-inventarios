import 'package:supabase_flutter/supabase_flutter.dart';

import '../../block/model/block_model.dart';
import '../model/filter_obj_model.dart';
import '../model/object_model.dart';

class ObjectRepo {
  static const String _id = 'id';
  static const String _object = 'object';
  static const String _createAt = 'create_at';
  static final _supabase = Supabase.instance.client;

  /// Obtiene una lista de objetos de la base de datos.
  ///
  /// Recibe un [BlockModel] : [block] y una lista [FilterObjModel] : [filterList]. 
  /// Si [filterList] no se encuentra vacía, realiza una búsqueda filtrada; de lo contrario,
  /// realiza una búsqueda completa de la tabla referenciada. La tabla de la base de datos donde
  /// se hará la búsqueda es obtenida mediante [BlockModel.tableName].
  /// 
  /// Después de la consulta convierte los datos obtenidos en una lista [ObjectModel].
  static Future<List<ObjectModel>> fetchObject(
      BlockModel block, List<FilterObjModel> filterList) async {
    List<Map<String, dynamic>> objsDB;
    List<ObjectModel> objList = [];
    ObjectModel obj;
    Map<String, dynamic> matchMap = {};

    if (filterList.isNotEmpty) {
      for (var flt in filterList) {
        if (flt.filter == FilterOperator.eq) {
          matchMap[flt.property.name] = flt.value;
        }
      }
      objsDB = await _supabase
          .from(block.tableName)
          .select<List<Map<String, dynamic>>>('*')
          .match(matchMap);
    } else {
      objsDB = await _supabase
          .from(block.tableName)
          .select<List<Map<String, dynamic>>>('*');
    }

    if (objsDB.isNotEmpty) {
      for (var objDB in objsDB) {
        obj = ObjectModel(
          id: objDB[_id],
          map: objDB[_object],
          createAt: DateTime.parse(objDB[_createAt]),
        );
        objList.add(obj);
      }
    }

    return objList;
  }
}
