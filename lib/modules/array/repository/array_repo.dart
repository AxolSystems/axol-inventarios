import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/array_model.dart';

class ArrayRepo {
  static const String _table = 'arrays';
  static const String _id = 'id';
  static const String _array = 'array';
  static final _supabase = Supabase.instance.client;

  static Future<List<ArrayModel>> fetchArray(List<String> idList) async {
    final List<ArrayModel> arrays = [];
    final List<Map<String, dynamic>> response;
    List<dynamic> listDynamic;
    List<String> listString = [];

    response = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .in_(_id, idList);

    if (response.isNotEmpty) {
      for (Map<String, dynamic> row in response) {
        listDynamic = row[_array];
        for (var x in listDynamic) {
          listString.add(x.toString());
        }
        arrays.add(ArrayModel(id: row[_id], list: listString, value: ''));
      }
    }

    return arrays;
  }

  static Future<List<String>> fetchArrayById(String id) async {
    final List<String> array = [];
    final List<Map<String, dynamic>> response;
    List<dynamic> listDynamic;

    response = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .eq(_id, id);

    if (response.isNotEmpty) {
      listDynamic = response.first[_array];
      for (var x in listDynamic) {
        array.add(x.toString());
      }
    }

    return array;
  }
}
