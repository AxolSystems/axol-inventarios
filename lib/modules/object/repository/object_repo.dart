import 'package:supabase_flutter/supabase_flutter.dart';

import '../../block/model/block_model.dart';
import '../model/filter_obj_model.dart';
import '../model/object_model.dart';

class ObjectRepo {
  static const String _id = 'id';
  static const String _object = 'object';
  static const String _createAt = 'create_at';
  static final _supabase = Supabase.instance.client;

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
        print(objDB);
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
